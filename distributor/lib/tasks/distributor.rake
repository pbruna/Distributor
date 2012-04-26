# encoding: utf-8
namespace :distributor do

  desc "Create a SSH Key"
  task  :create_ssh_key => :environment do
    ssh_key_file = "#{APP_CONFIG['ssh_key_file_path']}/#{APP_CONFIG['ssh_key_file']}"
    system "ssh-keygen -q -f #{Rails.root.to_s}/#{ssh_key_file}"
  end

  desc "Setup Admin User"
  task :build_admin => :environment do
    if User.are_any_admin?
      puts "Ya existe un usario administrador"
    else
      print "Ingrese su email: "
      email = STDIN.gets.chomp
      print "Ingrese su contraseña: "
      system "stty -echo"
      password = STDIN.gets.chomp
      print "\nConfirme su contraseña: "
      password_confirmation = STDIN.gets.chomp
      system "stty echo"
      print "\n"
      user = User.new(:email => email, :password => password, :password_confirmation => password_confirmation)
      user.admin = true
      if user.save
        puts "Usuario creado"
      else
        puts "No se pudo crear el usuario debido a: #{user.errors.full_messages.join(", ")}"
      end
    end
  end

end
