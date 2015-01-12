require 'fileutils'

module SecureArchive
  class Archiver
    def initialize(output, encryptor = SecureArchive::Encryptor::Plain.new)
      @output = Pathname.new(output)
      @encryptor = encryptor
    end

    def archive_tree(src)
      source = Pathname.new(src)
      output = @output
      output += source.basename unless src.is_a?(String) && src[-1..-1] == '/'
      encrypt_tree(source, output)
      cleanup_tree(output, source)
    end

  private

    def encrypt_tree(source, destination)
      FileUtils.mkdir_p(destination) unless destination.directory?
      Pathname.new(source).each_child do |file|
        target = destination + file.basename
        if file.directory? then
          encrypt_tree(file.realpath, target)
        elsif file.file? then
          # mtime manipulation has shown problems, the following fails:
          #     a.utime(b.atime, b.mtime)
          #     a.stat == b.stat
          # Compare time and allow up to 0.1s of difference
          if !target.exist? || (target.stat.mtime - file.stat.mtime).abs > 0.1 then
            @encryptor.encrypt_file(file, target)
            target.utime(file.atime, file.mtime)
          end
        end
      end
    end

    def cleanup_tree(dir, ref)
      Pathname.new(dir).each_child do |file|
        source = ref + file.basename
        if source.exist? then
          if file.directory? then
            cleanup_tree(file.realpath, ref + file.basename)
          end
        else
          file.rmtree
        end
      end
    end
  end
end
