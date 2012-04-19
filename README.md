# Distributor

Distributor is a software developed with Rails for uploading and syncing files from a central server to remote locations.


## Configuración S.O.
Distributor esta certificado para ser ejecutado en sistemas operativos Red Hat Linux 6 o similares como CentOS y Oracle Linux.

La instalación del S.O. queda fuera del alcance de esta guía, pero Distributor espera que la configuración del Sistema Operativo:

* Permita acceso HTTP/S hacia Internet, para instalación de dependencias.
* Tenga configurado el repositorio EPEL - http://fedoraproject.org/wiki/EPEL/es
* Se haya instalado el paquete puppet


## Instalación de Distributor

* Clonar con git
* Instalar Gems con bundle



## Configurando Distributor

### Servidor STMP
La configuración del servidor de correo se realiza en el archivo __config/initializers/smtp_config.rb__, se puede usar como base el archivo _config/initializers/smtp_config.rb.example_. Es necesario configurar al menos los siguientes parámetros:

* Hostname del Servidor donde se instaló Distributor
* Nombre/IP servidor de correos,
* Puerto

```ruby

Distributor::Application.config.action_mailer.default_url_options = { :host => "distributor.example.com" }

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address        => "mail.example.com",
  :port           => 587,
  :domain         => "example.com",
  :user_name      => "distributor@example.com",
  :password       => "super pass"
}
```

Después modificar la dirección de correo del emisor de los correos editando el archivo __config/initializers/devise.rb__ 

```ruby
config.mailer_sender = "distributor@example.com"
```

### Configurar Base de Datos
La configuración se realiza en el archivo __config/database.yml__

```yaml
production:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: distributor_production
  pool: 5
  username: distributor
  password:
  socket: /var/lib/mysql/mysql.sock
```
Más información sobre las opciones de configuración en http://bit.ly/JaFK4o

Luego se debe crear la base de datos, pare ello ejecutar el siguiente comando desde el directorio raíz de la aplicación.

```bash
$ RAILS_ENV=production rake db:create
```

### Crear usuario de Administración
Desde el directorio raíz de la aplicación ejecutar el siguiente comando y seguir las instrucciones

```bash
$ RAILS_ENV=production rake distributor:build_admin
```