# Домашнее задание к занятию "Использование Terraform в команде"

## Задание 1
  <em>Проверьте код с помощью tflint и checkov. Какие типы ошибок обнаружены в проекте?</em>

  ```
  Предупреждения TFLint
  Warning: Missing version constraint for provider "yandex" in "required_providers" (terraform_required_providers)
  Warning: Module source "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main" uses a default branch as ref (main) (terraform_module_pinned_source)
  Warning: variable "vm_db_name" is declared but not used (terraform_unused_declarations)

  Ошибки Checkov
  Check: CKV_YC_11: "Ensure security group is assigned to network interface."
          FAILED for resource: module.test-vm.yandex_compute_instance.vm[0]
          File: /.external_modules/github.com/udjin10/yandex_compute_instance/main/main.tf:24-73
          Calling File: /demonstration1/main.tf:32-48

  Check: CKV_YC_2: "Ensure compute instance does not have public IP."
          FAILED for resource: module.test-vm.yandex_compute_instance.vm[0]
          File: /.external_modules/github.com/udjin10/yandex_compute_instance/main/main.tf:24-73
          Calling File: /demonstration1/main.tf:32-48
  ```

## Задание 2
  * **Пункт 2.**  <em>Настройте YDB, S3 bucket, yandex service account, права доступа и мигрируйте State проекта в S3 с блокировками.</em>  
    Создание бакета  
    ![](/hw-05/backet.png)  
    
    Создание YDB и получение API endpoint  
    ![](/hw-05/db.png)  
    
    Создание таблицы блокировки  
    ![](/hw-05/table.png)  

    Создание сервисного аккаутна  
    ![](/hw-05/acc.png)  

    Создание ключа доступа  
    ![](/hw-05/key.png)  

    Настройка доступа к S3  
    ![](/hw-05/acl.png)  

    Настройка доступа для YDB  
    ![](/hw-05/access.png)  
    ![](/hw-05/role.png)  

    Инициализация проекта terraform и перенастройка бэкенда  
    ![](/hw-05/init.png)  
    ![](/hw-05/reconfigure.png)  

  * **Пункт 4,5.**  <em>Откройте terraform console, а в другом окне попробуйте запустить terraform apply, пришлите ответ об ошибке доступа к State</em>   
    ![](/hw-05/lock.png)  

  * **Пункт 6.**  <em>Принудительно разблокируйте State. Пришлите команду и вывод.</em>  
    ![](/hw-05/unlock.png)