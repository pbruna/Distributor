# encoding: utf-8
class PackagesController < ApplicationController
  
  def index
    @packages = Package.all
  end
  
  def show
    @package = Package.find(params[:id])
  end
  
  def edit
    @package = Package.find(params[:id])
  end
  
  def new
    @package = Package.new
  end
  
  def sincronize
    @package = Package.find(params[:id])
    servers = Server.where( :id => params[:servers].map {|s| s.to_i}).to_a
    @package.delay.sync(servers)
    flash[:notice] = "Ha comenzado la sincronización"
    redirect_to package_path(@package)
  end
  
  def create
    @package = Package.new(params[:package])
    if @package.save
      flash[:notice]="Archivo guardado correctamente"
      redirect_to package_path(@package)
    else
      flash[:error]="No fue posible subir el archivo"
      render :action => "new"
    end    
  end
  
  def update
    @package = Package.find(params[:id])
    respond_to do |format|
      if @package.update_attributes(params[:package])
        format.html {redirect_to package_path(@package), :notice => "Archivo actualizado correctamente"}
        format.json {head :no_content}
      else
        flash[:error] = "No fue posible guardar los cambios"
        format.html {render action: "edit" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @package = Package.find(params[:id])
    respond_to do |format|
      if @package.destroy
        format.html {redirect_to packages_path(), :notice => "Archivo eliminado correctamente"}
        format.json {head :no_content}
      else
        flash[:error] = "No se pudo eliminar el archivo"
        format.html {redirect_to packages_path}
        format.json {render json: @package.errors, status: :unprocessable_entity}
      end
    end
  end
  
end
