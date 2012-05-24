# Distributor

Distributor is a software developed with Rails for uploading and syncing files from a central server to remote locations.

## TODOS
- Documentar instalación y configuración:
* inicio automático de delayed_job con varios procesos (-n 10) con monit
* Traducir mensajes FLASH que faltan

- Barra de Progreso cuando se carga archivo
- Barra de Progreso cuando se activa servidor
- Mejorar el Look del correo enviado


## Configuración S.O.
Distributor esta certificado para ser ejecutado en sistemas operativos Red Hat Linux 6 o similares como CentOS y Oracle Linux.

La instalación del S.O. queda fuera del alcance de esta guía, pero Distributor espera que la configuración del Sistema Operativo:

* Permita acceso HTTP/S hacia Internet, para instalación de dependencias.
* Tenga configurado el repositorio EPEL - http://fedoraproject.org/wiki/EPEL/es
* Se haya instalado el paquete __puppet__

### Descargar Distributor
Se debe descargar el archivo zip y luego descomprimirlo.
La carpeta resultante tendrá dos directorios:

* __distributor/__ : es el directorio de la aplicación y su contenido debe ser copiado, con __rsync__, en /var/www/distributor. El usuario y grupo apache deben ser propietarios del directorio, y

* __puppet__/ : que contiene la configuración automática y su contenido debe ser copiado en /etc/puppet

### Configuración automática con puppet
Se debe copiar el contenido del directorio [puppet](https://github.com/pbruna/Distributor/tree/master/puppet) en el directorio /etc/puppet. El directorio /etc/puppet debería tener el siguiente contenido:

```bash
$ ls /etc/puppet/
auth.conf  manifests  modules  puppet.conf
```

Posteriormente se debe aplicar la configuración del Sistema Operativo ejecutando:

```bash
$ puppet apply /etc/puppet/manifests/default.pp
```

Este proceso puede demorar varios minutos, lo cual depende de la velocidad de acceso a Internet y la potencia del equipo.

## Configurando Distributor

### Instalar Dependencias
Dentro del directorio de la aplicación (/var/www/distributor), se debe ejecutar el comando __bundle__

```bash
$ bundle install
```

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
$ RAILS_ENV=production rake db:setup
```

### Crear usuario de Administración
Desde el directorio raíz de la aplicación ejecutar el siguiente comando y seguir las instrucciones

```bash
$ RAILS_ENV=production rake distributor:build_admin
```

### Crear llave de conexión
Desde el directorio raíz de la aplicación ejecutar el siguiente comando, el cual creará llaves SSH para la conexión con los servidores de sincronización. **NO** usar __passphrases__

```bash
$ RAILS_ENV=production rake distributor:create_ssh_key
```

### Compilar Assets
Se deben compilar los archivos CSS y Javascript, para ello ejecutar

```bash
$ RAILS_ENV=production rake assets:clean
$ RAILS_ENV=production rake assets:precompile
```