# Politica Diagnostic Setting En Azure

Esta aplicacion se usa para desplegar una iniciativa de politicas por medio de terraform en Azure con el fin de activar el diagnosting settings en los recuros de Azure.

## Installation

Se debe clonar el proyecto 

```bash
git clone url https://go2cloud@dev.azure.com/go2cloud/LANDINGZONE/_git/LANDINGZONE
```

## Uso

```python
Debe moficiar la URI del management gruop en el archivo de variables.tf

# Modificar la URI management gruop
En el archivo variables.tf y el archivo json policy_set_definitios\lib\policy_set_definition_es_deploy_diagnostics_loganalytics.tmpl.json


# Inicializar Terraform
Terraform init

# Desplegar las politicas
terraform apply


```