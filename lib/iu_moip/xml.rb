module IuMoip
  class XML
    autoload :CreateNode, 'iu_moip/xml/create_node'
    autoload :Base,       'iu_moip/xml/base'
    autoload :Pagador,    'iu_moip/xml/pagador'
    autoload :Boleto,     'iu_moip/xml/boleto'
    include CreateNode

    def doc
      @doc ||= Nokogiri::XML::Document.new
    end

    def to_xml
      doc.to_xml
    end

    def enviar_instrucao
      @enviar_instrucao ||= create_node(doc, 'EnviarInstrucao')
    end

    def instrucao_unica
      @instrucao_unica ||= create_node(enviar_instrucao, 'InstrucaoUnica', 'TipoValidacao' => 'Transparente')
    end

    def razao(str)
      @razao ||= create_node(instrucao_unica, 'Razao', str)
    end

    def valores(valor, acrescimo = 0, deducao = 0)
      unless @valores
        @valores = create_node(instrucao_unica, 'Valores')
        create_node(@valores, 'Valor', format_money(valor), 'Moeda' => 'BRL')
        create_node(@valores, 'Acrescimo', format_money(acrescimo), 'Moeda' => 'BRL')
        create_node(@valores, 'Deducao', format_money(deducao), 'Moeda' => 'BRL')
      end
      @valores
    end

    def id_proprio(id = nil)
      if id
        self.id_proprio = id
      end
      @id_proprio
    end

    def id_proprio=(id)
      @id_proprio ||= create_node(instrucao_unica, 'IdProprio', id)
    end

    def comisoes
      @comissoes ||= create_node(instrucao_unica, 'Comissoes')
    end

    def add_comissao(login, motivo, opts = { })
      fixo = opts[:fixo]
      perc = opts[:percentual]

      # TODO: error
      return unless login && motivo && (fixo || perc)

      c = create_node(comissoes, 'Comissionamento')
      create_node(c, 'LoginMoIP', login)
      create_node(comissoes, 'Razao', motivo)
      create_node(comissoes, 'ValorFixo', format_money(fixo))       if fixo
      create_node(comissoes, 'ValorPercentual', format_money(perc)) if perc
      comissoes
    end

    def recebedor(login, apelido)
      return unless login and apelido
      @recebedor = create_node(instrucao_unica, 'Recebedor')
      create_node(@recebedor, 'LoginMoIP', login)
      create_node(@recebedor, 'Apelido', apelido)
    end

    def pagador
      @pagador ||= Pagador.new(instrucao_unica)
    end

    def pagador_valid?(attrs)
      f = [:nome, :email, :id_pagador, :logradouro, :numero, :cidade, :estado, :cep, :telefone_fixo]
      (f & attrs.keys).size >= f.size
    end

    def format_money(val)
      '%02.02f' % val
    end

    def formas_pagamento
      @formas_pagamento ||= create_node('FormasPagamento')
    end

    def add_forma_pagamento(type)
      type = snake_case_to_camel_case(type)
      set_node(formas_pagamento, 'FormaPagamento', type)
    end

    def entrega(valor_frente)
      unless @entrega
        @entrega ||= create_node(instrucao_unica, 'Entrega')
        set_node(@entrega, 'Destino', 'MesmoCobranca')
        cf = create_node(@entrega, 'CalculoFrete')
        # TODO: falta tipo correio
        set_node(cf, 'Tipo', 'Proprio')
        set_node(cf, 'ValorFixo', format_money(valor_frente))
      end
      @entrega
    end

    def messages
      @messages ||= create_node(instrucao_unica, 'Messagens')
    end

    def add_messagem(_message)
      set_node(messages, 'Message', _message)
    end

    def boleto
      @boleto ||= Boleto.new(instrucao_unica)
    end
  end
end

__END__

<EnviarInstrucao>
    <InstrucaoUnica TipoValidacao="Transparente">          
        <Boleto>
            <DataVencimento>2000-12-31T12:00:00.000-03:00</DataVencimento>
            <Instrucao1>Primeira linha de mensagem adicional</Instrucao1>
            <Instrucao2>Segunda linha</Instrucao2>
            <Instrucao3>Terceira linha</Instrucao3>
            <URLLogo>http://meusite.com.br/meulogo.jpg</URLLogo>
        </Boleto>
 
        <URLNotificacao>http://meusite.com.br/notificacao/</URLNotificacao>
         
        <URLRetorno>http://meusite.com.br/</URLRetorno>
 
    </InstrucaoUnica>
</EnviarInstrucao>