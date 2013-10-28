module IuMoip
  class XML
    class Boleto < Base
      def self.implement_methods
        [:dias_expiracao, :data_vencimento, :instrucao1, :instrucao2, :instrucao3, :url_logo]
      end
    end
  end
end