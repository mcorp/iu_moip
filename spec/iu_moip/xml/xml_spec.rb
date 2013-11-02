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
  end
end