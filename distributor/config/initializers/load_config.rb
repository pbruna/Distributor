# TODO: Mover todo tipo de configuración a este archivo
# TODO: Actualizar README con esta informacion

APP_CONFIG = YAML.load_file("#{Rails.root}/config/distributor.yml")[Rails.env]