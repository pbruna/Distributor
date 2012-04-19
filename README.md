# Distributor

Distributor is a software developed with Rails for uploading and syncing files from a central server to remote locations.

## Instalación

### Instalación S.O.

### Instalación de Distributor

* Clonar con git
* Instalar Gems con bundle



### Configurando Distributor

#### Servidor STMP
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