require 'spec_helper'

require 'tempfile'

describe SecureArchive::Encryptor::Gpg do
  let(:recipients) { [ 'romain@blogreen.org' ] }
  let(:gpg) { SecureArchive::Encryptor::Gpg.new(recipients) }

  before do
    @src = Tempfile.new('secure_archive')
    @dst = Tempfile.new('secure_archive')

    @src.write('Hello, world!')
    @src.close
  end

  after do
    @src.unlink
    @dst.unlink
  end

  it 'encrypts data' do
    gpg.encrypt_file(@src.path, @dst.path)

    expect(File.size?(@dst.path)).to be_truthy
  end

  describe 'with invalid recipients' do
    let(:recipients) { [ 'invalid@example.com' ] }

    it 'raises exception' do
      expect { gpg.encrypt_file(@src.path, @dst.path) }.to raise_exception(SecureArchive::Encryptor::Gpg::RecipientNotInKeyring)
    end
  end
end
