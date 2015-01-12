module SecureArchive
  module Encryptor
    class Plain
      def encrypt_file(source, destination)
        destination.open('w') do |w|
          source.open do |r|
            buf = r.read(1024 * 16)
            while (buf) do
              w.write(buf)
              buf = r.read(1024 * 16)
            end
          end
        end
      end
    end
  end
end


