# Домашнее задание к занятию "Продвинутые методы работы с Terraform"

## Задание 1
  * **Пункт 2**  
    * <em>Создайте 1 ВМ</em>
        ```hcl
        module "test-vm" {
        <...>
        instance_count  = 1
        <...>
        }
        ```
 
    * <em>В файле cloud-init.yml необходимо использовать переменную для ssh ключа</em>
        ```yaml
        #cloud-config
        users:
          - name: ubuntu
            <...>
            ssh_authorized_keys:
              - ${ tmpl_ssh_public_key }
            <...>
        ```

    * <em>Передайте ssh-ключ в функцию template_file в блоке vars ={}</em>
        ```hcl
        locals{
          ssh_pub_key = file("~/.ssh/id_rsa.pub")
        }
        
        data "template_file" "cloudinit" {
          template = file("./cloud-init.yml")
  
          vars = {
            tmpl_ssh_public_key      = local.ssh_pub_key
            <...>
          }
        }
        ```

  * **Пункт 3**  
    * <em>Добавьте в файл cloud-init.yml установку nginx</em>
        ```hcl
        ### Cloud init variables
        variable "cloud_init_packages" {
          type = list(string)
          default = []
        }
        
        cloud_init_packages = [
            "vim",
            "nginx"
        ]

        data "template_file" "cloudinit" {
        template = file("./cloud-init.yml")
  
          vars = {
            tmpl_ssh_public_key      = local.ssh_pub_key
            tmpl_cloud_init_packages = jsonencode(var.cloud_init_packages)
          }
        }
        ```
        ```yaml
        #cloud-config
        <...>
        packages: ${ tmpl_cloud_init_packages }
        <...>
        ```
  
  * **Пункт 4**  
    * <em>Предоставьте скриншот подключения к консоли и вывод команды sudo nginx -t</em>  
        ![](/hw-04/nginx_t.png)
    
    * <em>Ссылки на файлы из задания</em>  
    ![main.tf](/src/main.tf)  
    ![locals.tf](/src/locals.tf)  
    ![variables.tf](/src/variables.tf)  
    ![cloud-init.auto.tfvars](/src/cloud-init.auto.tfvars)  
    ![cloud-init.yml](/src/cloud-init.yml)  

## Задание 2
  * **Пункт 1**  
    <em>Напишите локальный модуль vpc, который будет создавать 2 ресурса: одну сеть и одну подсеть...</em>  
    ![](/hw-04/module_vpc_01.png)  
    
    ![](/hw-04/module_vpc_02.png)  

    ![/src/modules/vpc/main.tf](/src/modules/vpc/main.tf)  

  * **Пункт 2**  
    <em>Модуль должен возвращать значения vpc.id и subnet.id</em>  
    ![](/hw-04/module_vpc_03.png)  

    ![/src/modules/vpc/output.tf](/src/modules/vpc/output.tf)  
  
  * **Пункт 3**  
    <em>Замените ресурсы yandex_vpc_network и yandex_vpc_subnet, созданным модулем</em>  
    ![](/hw-04/module_vpc_04.png)  

    ![/src/main.tf](/src/main.tf)  

  * **Пункт 4**  
    <em>Сгенерируйте документацию к модулю с помощью terraform-docs</em>

    ---
    ## Requirements

    | Name | Version |
    |------|---------|
    | <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |

    ## Providers

    | Name | Version |
    |------|---------|
    | <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

    ## Modules

    | Name | Source | Version |
    |------|--------|---------|
    | <a name="module_test-vm"></a> [test-vm](#module\_test-vm) | git::https://github.com/udjin10/yandex_compute_instance.git | main |
    | <a name="module_vpc_dev"></a> [vpc\_dev](#module\_vpc\_dev) | ./modules/vpc | n/a |

    ## Resources

    | Name | Type |
    |------|------|
    | [template_file.cloudinit](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

    ## Inputs

    | Name | Description | Type | Default | Required |
    |------|-------------|------|---------|:--------:|
    | <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id | `string` | n/a | yes |
    | <a name="input_cloud_init_packages"></a> [cloud\_init\_packages](#input\_cloud\_init\_packages) | ## Cloud init variables | `list(string)` | `[]` | no |
    | <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | https://cloud.yandex.ru/docs/overview/concepts/geo-scope | `string` | `"ru-central1-a"` | no |
    | <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id | `string` | n/a | yes |
    | <a name="input_token"></a> [token](#input\_token) | OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token | `string` | n/a | yes |
    | <a name="input_vm_db_name"></a> [vm\_db\_name](#input\_vm\_db\_name) | example vm\_db\_ prefix | `string` | `"netology-develop-platform-db"` | no |
    | <a name="input_vm_web_name"></a> [vm\_web\_name](#input\_vm\_web\_name) | example vm\_web\_ prefix | `string` | `"netology-develop-platform-web"` | no |
    | <a name="input_vms_ssh_root_key"></a> [vms\_ssh\_root\_key](#input\_vms\_ssh\_root\_key) | ssh-keygen -t ed25519 | `string` | `"your_ssh_ed25519_key"` | no |

    ## Outputs

    No outputs.

    ---

## Задание 3  
  * **Пункт 1**  
      <em>Выведите список ресурсов в стейте</em>  
      ![](/hw-04/tf_state_list.png)  

  * **Пункт 2**  
    <em>Удалите из стейта модуль vpc</em>  
    ![](/hw-04/tf_rm_01.png)  

    ![](/hw-04/tf_rm_02.png)

  * **Пункт 3**  
    <em>Импортируйте его обратно. Проверьте terraform plan - изменений быть не должно</em>  
    ![](/hw-04/tfp.png)  
