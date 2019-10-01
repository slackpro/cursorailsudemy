namespace :dev do

	DEFALT_PASSWORD = 123456

  desc "Configura o ambiente de desemvolvimento"
  task setup: :environment do
  	if Rails.env.development?

	show_spinner("Apagando BD...") {%x(rails db:drop)}
  show_spinner("Creando BD...") {%x(rails db:create)}
	show_spinner("Migrando BD...") {%x(rails db:migrate)}
	show_spinner("Criando o Administrador padão...") {%x(rails dev:add_default_admin)}
	show_spinner("Criando o Usuário padão...") {%x(rails dev:add_default_user)}
  	
  	else
  		puts "Você não esta em ambiente de desemvolvimento!"
  	end
end

	desc "Adiciona o Administrador padrão"
	task add_default_admin: :environment do
		Admin.create!(
			email: 'admin@admin.com',
			password: DEFALT_PASSWORD,
			password_confirmation: DEFALT_PASSWORD
		)
	end

	desc "Adiciona o Usuário padrão"
	task add_default_user: :environment do
		User.create!(
			email: 'user@user.com',
			password: DEFALT_PASSWORD,
			password_confirmation: DEFALT_PASSWORD
		)
	end

private

def show_spinner(msg_start, msg_end = "Concluido!")
	spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
	spinner.auto_spin
	yield
	spinner.success("(#{msg_end})")
	
	end
end