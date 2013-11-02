module IuMoip
  class XML
    class Boleto < Base
      implement_set_nodes :dias_expiracao, :data_vencimento, :instrucao1, :instrucao2, :instrucao3, :url_logo
    end
  end
end