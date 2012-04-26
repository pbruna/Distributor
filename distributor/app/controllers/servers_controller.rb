class ServersController < ApplicationController

  def show
    @server = Server.find(params[:id])
  end
  
  def index
    @servers = Server.all
  end
  
  def edit
    @server = Server.find(params[:id])
  end
  
  def new
    @server = Server.new
  end
  
  def create
    @server = Server.new(params[:server])
    if @server.save
      flash[:notice]="Servidor creado correctamente"
      redirect_to server_path(@server)
    else
      flash[:error]="No fue posible agregar el servidor"
      render :action => "new"
    end    
  end
  
  def update
    @server = Server.find(params[:id])
    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html {redirect_to server_path(@server), :notice => "Servidor actualizado correctamente"}
        format.json {head :no_content}
      else
        flash[:error] = "No fue posible guardar los cambios"
        format.html {render action: "edit" }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @server = Server.find(params[:id])
    respond_to do |format|
      if @server.destroy
        format.html {redirect_to servers_path(), :notice => "Servidor eliminado correctamente"}
        format.json {head :no_content}
      else
        flash[:error] = @server.errors[:base].first
        format.html {redirect_to servers_path}
        format.json {render json: @server.errors, status: :unprocessable_entity}
      end
    end
  end
  
end
