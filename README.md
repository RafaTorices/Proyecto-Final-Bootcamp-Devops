# Keep-DevOps-Triangel-app

Repositorio para el proyecto final del curso de DevOps and Cloud Computing VIII de KeepCoding.

# Equipo de Trabajo

- Yuldor Librán
- [Albert Fernández](https://github.com/albertferal)
- Jeff
- [Rafael Torices](https://github.com/RafaTorices)

# Descripción del proyecto

- [Desarrollo de una aplicación](app/Readme.md)

    ![Alt text](/doc_images/triangle-app-app.png)

- [Despliegue de la aplicación en un entorno de desarrollo](app/Readme.md)
- Despliegue automatizado de un cluster de Kubernetes en un entorno de producción
- CI/CD, integración continua y despliegue continuo
- Monitorización de la aplicación.

# Tecnologías utilizadas

- Aplicación
    - Python
    - Flask
    - MySQL
    - Redis
    - MongoDB

- Entorno de desarrollo
    - Docker
    - Docker Compose

- Entorno de producción
    - EKS (Elastic Kubernetes Service) de AWS
    - Terraform
    - [Helm Charts](/helm/Readme.md)
    - [ArgoCD](/argocd/Readme.md)

- CI/CD
    - GitHub Actions
        - [test_and_docs.yml](.github/workflows/test_and_docs.yml):
            - Este flujo de trabajo consta de 2 jobs y realiza las siguientes acciones:
                - JOB TESTING-AND-SONARCLOUD:
                    - Configuramos unas variables para, por si hiciera falta en los tests, generar una base de datos MYSQL con docker.
                    - Clonar el código del repositorio: Descarga el código del repositorio para realizar las pruebas y el análisis estático.
                    - Configurar el entorno de Python: Utiliza la acción setup-python para configurar la versión de Python que se utilizará en el entorno de ejecución.
                    - Instalar y verificar dependencias: Actualiza pip, instala las dependencias del proyecto desde el archivo [requirements.txt](app/requirements.txt) y muestra la lista de dependencias instaladas.
                    - Arranca un contenedor MYSQL por si se hicieran nuevos tests que requirieran una db para ser ejecutados.
                    - Ejecutar pruebas y generar informes de cobertura: Utiliza pytest para ejecutar las pruebas del proyecto ubicadas en [test_app_py](app/src/tests/test_app.py) y genera un informe de cobertura, el cual será necesario para que SonarCloud pueda acceder a él.
                    - Ejecutar Pylint para el análisis estático del código: Utiliza Pylint para realizar análisis estático del código en la carpeta app y establece un umbral mínimo de puntuación (--fail-under=1.0).
                    - Finalizamos el pipeline ejecutando un scan del código con SonarCloud. Para ello, necesitamos de una serie de [propiedades](sonar-project.properties) definidas en la raíz de nuestro proyecto. Al terminar, se muestra la [URL de nuestro proyecto](https://sonarcloud.io/project/overview?id=KeepDevOpsTriangel_Keep-DevOps-Triangel-app), donde se pueden ver los resultados de todo el proceso.

                - JOB SNYK:
                    - Este trabajo "snyk" se ejecutará solo después de que testing haya completado con éxito. Las dependencias entre trabajos permiten establecer un orden específico de ejecución.
                    - Su función principal es analizar las dependencias del proyecto, incluyendo bibliotecas y paquetes de terceros, en busca de vulnerabilidades de seguridad conocidas. Podemos acceder a la interfaz de Snyk en nuestro proyecto --> [AQUI](https://app.snyk.io/org/keepdevopstriangel).

                - JOB GENERATE DOCS:
                    - Este trabajo "generate-docs" solo se ejecutará tras el éxito de los jobs anteriores. Las dependencias entre trabajos permiten establecer un orden específico de ejecución.
                    - Asume los mismos pasos que el job "testing-and-sonarcloud" para clonar el repo, configurar el entorno python e instalar las dependencias necesarias.
                    - Elimina la carpeta "docs", si la hubiera, para asegurar una generación limpia.
                    - Crea una nueva carpeta "docs" y utiliza pdoc para generar la documentación en esa carpeta a partir del código fuente ubicado en src/application.
                    - Utiliza la acción "actions/upload-artifact@" para empaquetar y cargar la carpeta docs como un artefacto llamado documentation. Este artefacto puede ser accesible después en GitHub, tal como se observa en la siguiente imagen:
                    ((IMAGEN DE DND ESTÁ EL ARTEFACTO, DEBAJO DEL PIPELINE))
        

        - [release.yml](.github/workflows/release.yml): ((SE CAMBIARÁ POR SEMANTIC RELEASE))
            - IMPORTANTE: ESTE FLUJO DE TRABAJO SÓLO SE ACTIVA CUANDO LE DAMOS AL PUSH UNA ETIQUETA QUE EMPIECE POR "V". HAY MODOS DE SOBREESCRIBIR ETIQUETAS PARA NO TENER QUE PONER UNA NUEVA CADA VEZ QUE QUEREMOS EJECUTARLO PARA PRUEBAS, EJEMPLO CON "V0.1.BETA" (Ejecutar los comandos en el órden indicado):
            ```
              git tag -d v0.1.beta  # Eliminar etiqueta localmente
              git push origin :refs/tags/v0.1.beta  # Eliminar etiqueta en el remoto
              git tag -a v0.1.beta -m "Versión 0.1.beta"  # Crear nueva etiqueta localmente
              git push origin v0.1.beta  # Empujar nueva etiqueta al remoto
            ```
            Ejecutar los comandos en el órden indicado.
            - Este flujo de trabajo realiza las siguientes acciones:
                1. Clonar el código del repositorio: Descarga el código del repositorio para construir la imagen de Docker.
                2. Iniciar sesión en el registro de GitHub Packages: Utiliza la acción docker/login-action para autenticarse en el registro de GitHub Packages utilizando el token de GitHub.
                3. Iniciar sesión en el registro de Docker Hub: Utiliza la acción docker/login-action para autenticarse en Docker Hub utilizando el token de Docker Hub.
                4. Extraer metadatos para Docker: Utiliza docker/metadata-action para extraer información sobre las imágenes, como tags y labels, tanto para GitHub Packages como para Docker Hub.
                5. Guardar estado y establecer salidas: Guarda en el entorno de GitHub (GITHUB_ENV) las rutas de las imágenes de GitHub Packages y Docker Hub.
                6. Construir y enviar la imagen de Docker en [nuestro perfil](https://hub.docker.com/repository/docker/kctriangle/triangle-bot/general). Utiliza docker/build-push-action para construir la imagen de Docker desde el contexto ./app y subirla a GitHub Packages. Se aplican las etiquetas y labels extraídos en el paso anterior.



- Monitorización
    - Prometheus
    - Grafana

# Fuentes de información

- [Documentación de AWS](https://docs.aws.amazon.com/es_es/)
- [Documentación de Docker](https://docs.docker.com/)
- [Documentación de Docker Compose](https://docs.docker.com/compose/)
- [Documentación de Terraform](https://www.terraform.io/docs/index.html)
- [Documentación de Helm](https://helm.sh/docs/)
- [Documentación de ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
- [Documentación de CircleCI](https://circleci.com/docs/)
- [Documentación de GitHub Actions](https://docs.github.com/es/actions)
- [Documentación de Prometheus](https://prometheus.io/docs/introduction/overview/)
- [Documentación de Grafana](https://grafana.com/docs/grafana/latest/)
- [Documentación de Ansible](https://docs.ansible.com/ansible/latest/index.html)
- [Documentación de Kubernetes](https://kubernetes.io/docs/home/)
- [Documentación de Flask](https://flask.palletsprojects.com/en/1.1.x/)
- [Documentación de MySQL](https://dev.mysql.com/doc/)
- [Documentación de Python](https://docs.python.org/3/)


