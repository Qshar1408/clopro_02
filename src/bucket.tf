// Создаем случайный суффикс для уникальности имени bucket
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

// Create SA
resource "yandex_iam_service_account" "sa-bucket" {
    name      = "sa-for-bucket"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
    folder_id = var.yandex_folder_id
    role      = "storage.editor"
    member    = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
    depends_on = [yandex_iam_service_account.sa-bucket]
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = yandex_iam_service_account.sa-bucket.id
    description        = "static access key for bucket"
}

// Создаем bucket
resource "yandex_storage_bucket" "netology-bucket" {
    # Уникальное имя чтобы избежать конфликтов
    bucket = "gribanov-netology-bucket-${random_id.bucket_suffix.hex}"
    
    # Используем ключи от созданного SA
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key

 # Настройка публичного доступа
    anonymous_access_flags {
        read = true
        list = false
    }
    
    # Опционально: ограничение размера
    max_size = 1073741824 # 1GB
    
    # Опционально: настройки для веб-сайта
    website {
        index_document = "index.html"
        error_document = "error.html"
    }
}


// Add picture to bucket
resource "yandex_storage_object" "object-1" {
    access_key = "${var.yandex_storage_access_key}"
    secret_key = "${var.yandex_storage_secret_key}"
    bucket = yandex_storage_bucket.netology-bucket.bucket
    key = "test_pic.jpg"
    source = "data/test_pic.jpg"
    acl    = "public-read"
    depends_on = [yandex_storage_bucket.netology-bucket]
}

// Выводим информацию о созданных ресурсах
output "bucket_info" {
    value = {
        bucket_name = yandex_storage_bucket.netology-bucket.bucket
        access_key  = yandex_iam_service_account_static_access_key.sa-static-key.access_key
        secret_key  = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
        sa_id       = yandex_iam_service_account.sa-bucket.id
        url         = "https://${yandex_storage_bucket.netology-bucket.bucket}.storage.yandexcloud.net"
    }
    sensitive = true
}