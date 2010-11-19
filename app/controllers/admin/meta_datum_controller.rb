class Admin::MetaDatumController < ApplicationController
  layout :layout

  def index
    @admin_meta_data = Admin::MetaData.all

    respond_to do |format|
      format.html
      format.xml  { render :xml => @admin_meta_data }
    end
  end

  def new
    @admin_meta_datum = Admin::MetaData.new(:relative_path => params[:p])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @admin_meta_data }
    end
  end

  def create
    @admin_meta_data = Admin::MetaData.new(params[:admin_meta_data])

    respond_to do |format|
      if @admin_meta_data.save
        format.html { redirect_to(@admin_meta_data, :notice => 'Meta data was successfully created.') }
        format.xml  { render :xml => @admin_meta_data, :status => :created, :location => @admin_meta_data }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_meta_data.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @admin_meta_datum = Admin::MetaData.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @admin_meta_datum }
    end
  end

  def edit
    @admin_meta_datum = Admin::MetaData.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @admin_meta_datum }
    end
  end

  def update
    @admin_meta_datum = Admin::MetaData.find(params[:id])

    respond_to do |format|
      if @admin_meta_datum.update_attributes(params[:admin_meta_data])
        format.html { redirect_to(@admin_meta_datum, :notice => 'Meta Data was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_meta_datum.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_meta_datum = Admin::MetaData.find(params[:id])
    @admin_meta_datum.destroy

    respond_to do |format|
      format.html { redirect_to(admin_meta_datum_index_path, :notice => 'Meta data deleted.') }
      format.xml  { head :ok }
    end
  end

end
