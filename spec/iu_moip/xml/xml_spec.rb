require 'spec_helper'

describe IuMoip::XML do
  context '#general methods' do
    it '#format_money' do
      subject.format_money(4.6).should == '4.60'
      subject.format_money(107695966.6345345).should == '107695966.63'
      subject.format_money(6.6385345).should == '6.64'
    end
  end

  context '#XML' do
    it '#instrucao_unica' do
      subject.instrucao_unica
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\"/>\n</EnviarInstrucao>\n"
    end

    it '#razao' do
      subject.razao('mimimi')
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\">\n    <Razao>mimimi</Razao>\n  </InstrucaoUnica>\n</EnviarInstrucao>\n"
    end

    it '#add_forma_pagamento' do
      subject.add_forma_pagamento(:boleto_bancario)
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\">\n    <FormasPagamento>\n      <FormaPagamento>BoletoBancario</FormaPagamento>\n    </FormasPagamento>\n  </InstrucaoUnica>\n</EnviarInstrucao>\n"
    end

    it 'add_message' do
      subject.add_messagem('mensagem!')
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\">\n    <Messagens>\n      <Message>mensagem!</Message>\n    </Messagens>\n  </InstrucaoUnica>\n</EnviarInstrucao>\n"
    end

    it '#entrega' do
      subject.entrega(10.3)
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\">\n    <Entrega>\n      <Destino>MesmoCobranca</Destino>\n      <CalculoFrete>\n        <Tipo>Proprio</Tipo>\n        <ValorFixo>10.30</ValorFixo>\n      </CalculoFrete>\n    </Entrega>\n  </InstrucaoUnica>\n</EnviarInstrucao>\n"
    end

    it '#recebedor' do
      subject.recebedor('login@moip', 'apelido')
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\">\n    <Recebedor>\n      <LoginMoIP>login@moip</LoginMoIP>\n      <Apelido>apelido</Apelido>\n    </Recebedor>\n  </InstrucaoUnica>\n</EnviarInstrucao>\n"
    end

    it '#add_comissao' do
      subject.add_comissao('login@moip', 'leecher', fixo: 2.41, percentual: 1.02)
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\">\n    <Comissoes>\n      <Comissionamento>\n        <LoginMoIP>login@moip</LoginMoIP>\n      </Comissionamento>\n      <Razao>leecher</Razao>\n      <ValorFixo>2.41</ValorFixo>\n      <ValorPercentual>1.02</ValorPercentual>\n    </Comissoes>\n  </InstrucaoUnica>\n</EnviarInstrucao>\n"
    end

    it '#id_proprio' do
      subject.id_proprio('lalala')
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\">\n    <IdProprio>lalala</IdProprio>\n  </InstrucaoUnica>\n</EnviarInstrucao>\n"
    end

    it '#valores' do
      subject.valores(1, 2, 3)
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\">\n    <Valores>\n      <Valor Moeda=\"BRL\">1.00</Valor>\n      <Acrescimo Moeda=\"BRL\">2.00</Acrescimo>\n      <Deducao Moeda=\"BRL\">3.00</Deducao>\n    </Valores>\n  </InstrucaoUnica>\n</EnviarInstrucao>\n"
    end

    it '@boleto' do
      {dias_expiracao: '1',
       data_vencimento: '2013-10-20',
       instrucao1: 'Instrucao 1',
       instrucao2: 'Instrucao 2',
       instrucao3: 'Instrucao 3',
       url_logo: 'http://url.to/logo', }.each do |k, v|
        subject.boleto.send("#{k}=", v)
        subject.boleto.send(k).should == v
      end
      subject.to_xml.should == "<?xml version=\"1.0\"?>\n<EnviarInstrucao>\n  <InstrucaoUnica TipoValidacao=\"Transparente\">\n    <Boleto>\n      <DiasExpiracao>1</DiasExpiracao>\n      <DataVencimento>2013-10-20</DataVencimento>\n      <Instrucao1>Instrucao 1</Instrucao1>\n      <Instrucao2>Instrucao 2</Instrucao2>\n      <Instrucao3>Instrucao 3</Instrucao3>\n      <URLLogo>http://url.to/logo</URLLogo>\n    </Boleto>\n  </InstrucaoUnica>\n</EnviarInstrucao>\n"
    end
  end
end