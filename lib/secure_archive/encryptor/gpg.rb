require 'gpgme'

module SecureArchive
  module Encryptor
    class Gpg
      class RecipientNotInKeyring < StandardError
      end

      def initialize(recipients)
        @crypto = GPGME::Crypto.new
        recipients.each do |recipient|
          if GPGME::Key.find(:public, recipient).count == 0 then
            raise RecipientNotInKeyring, "Recipient #{recipient} does not exist in keyring"
          end
        end
        @recipients = recipients
      end

      def encrypt_file(source, destination)
        File.open(destination, 'w') do |w|
          @crypto.encrypt(File.open(source), recipients: @recipients, output: w, always_trust: true)
        end
      end
    end
  end
end
