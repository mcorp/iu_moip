module IuMoip
  class XML
    class Pagador < IuMoip::XML::Base
      class EnderecoCobranca < IuMoip::XML::Base
        implement_set_nodes :logradouro, :numero, :complemento, :bairro, :cep, :cidade, :estado, :pais, :telefone_fixo
      end
    end
  end
end