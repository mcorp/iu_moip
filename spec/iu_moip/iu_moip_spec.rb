require 'spec_helper'

describe IuMoip::Client do
  let(:login) { 'something' }
  let(:pass) { 'other' }
  let(:enviar_instrucao_unica_response) { {"EnviarInstrucaoUnicaResponse"=>{"Resposta"=>{"ID"=>"201311031059245570000004184720", "Status"=>"Sucesso", "Token"=>"52U0V1M3G1R1A073L1N0A509P2D4B54577U0P0M0S0T0A0J4S1G8V4K762P0"}}} }
  let(:xmfault_response) { {"XMLFault"=>{"faultstring"=>"javax.xml.stream.XMLStreamException: ParseError at [row,col]:[26,1]\nMessage: Premature end of file."}} }
  let(:resposta) { enviar_instrucao_unica_response['EnviarInstrucaoUnicaResponse']['Resposta'] }
  subject { IuMoip::Client.new(login, pass) }
  context '#helpers' do
    it '#merge_vars' do
      subject.merge_vars('blabla/#{teste}', teste: 1234).should == 'blabla/1234'
      subject.merge_vars('blabla/#{teste}', 'teste' => 1234).should == 'blabla/1234'
      subject.merge_vars('blabla/#{teste}/#{teste}', 'teste' => 1234).should == 'blabla/1234/1234'
      subject.merge_vars('blabla/teste', {}).should == 'blabla/teste'
    end

    it '#hash_to_openstruct' do
      o = subject.hash_to_openstruct(resposta)
      o.id.should     == resposta['ID']
      o.status.should == resposta['Status']
      o.token.should  == resposta['Token']
    end

    context '#last_response=' do
      it 'xmfault_response' do
        subject.last_response = xmfault_response
        subject.last_response.status.should      == 'XMLFault'
        subject.last_response.faultstring.should == xmfault_response['XMLFault']['faultstring']
      end

      it 'enviar_instrucao_unica_response' do
        subject.last_response = enviar_instrucao_unica_response
        subject.last_response.id     = resposta['ID']
        subject.last_response.status = resposta['Status']
        subject.last_response.token  = resposta['Token']
      end
    end
  end
end