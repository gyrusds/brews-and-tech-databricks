# Brews & Tech Databricks

## Infraestructura

Hay dos directorios de infraestructura para este proyecto:

- __/infra_azure__. Despliega la infra de Azure para levantar el workspace de Databricks. El coste de esta infraestructura es 0$, por lo que no es necesario destruirla para reducir costes.

- __/infra_databricks__. Despliega los elementos dentro de databricks.
    Este terraform despliega actualmente el fichero `notebooks/hello_world.py` como notebook de databricks.
    Este repositorio tiene una dependencia del anterior. Para desplegar en el workspace necesita el host, por lo que lo lee del tfstate de _infra\_azure_.

Toda la documentación oficial sobre el provider de Databricks de Terraform está en la [documentación oficial de Terraform](https://registry.terraform.io/providers/databricks/databricks/latest/docs).

## HOW-TOs

### Desplegar la infraestructura.

1. Loguear en Azure.

    ```sh
    az login
    ```

2. (Sólo la primera vez) Desplegar la infra de Azure. Si ya está el workspace creado y no se ha hecho ningún cambio ahí no es necesario este paso.

    ```sh
    cd infra_azure
    terraform init
    terraform apply
    ```

3. Desplegar la infra de Databricks.

    ```sh
    cd infra_databricks
    terraform init
    terraform apply
    ```

### Eliminar la infraestructura

Para no incurrir en costes se debe eliminar la infraestructura desplegada dentro de __infra_databricks__ siguiendo los siguientes pasos:

```sh
cd infra_databricks
terraform init
terraform destroy
```

El comando `destroy` nos pedirá confirmación al igual que el `apply`.
