class LogradourosController < ApplicationController
  before_action :set_logradouro, only: [:show, :update]

  def index
    if params[:query]
      query = params[:query].deep_symbolize_keys
      @logradouros = Logradouro.join.filter(query)
      @total = @logradouros.count
      @logradouros = @logradouros.page(params[:page]).per(20)
    else
      @logradouros = Logradouro.join.all
    end
  end

  def show

  end

  def create
    @logradouro = Logradouro.new logradouro_params

    if @logradouro.save
      render :show
    else
      render json: { errors: @logradouro.errors.full_messages }, status: 422
    end
  end

  def update
    if @logradouro.update logradouro_params
      render :show
    else
      render json: { errors: @logradouro.errors.full_messages }, status: 422
    end
  end

private

  def set_logradouro
    @logradouro = Logradouro.join.find(params[:id])
  end

  def logradouro_params
    params.require(:logradouro).permit(:nome, :titulo_logradouro_id, :logradouro_tipo_id,
                                        :municipio_id, :ativo, :nome_popular,
                                        logradouro_ceps_attributes: [:id, :ativo, :cep_id, :_destroy],
                                        logradouro_bairros_attributes: [:id, :bairro_id, :_destroy]
                                        )
  end
end
