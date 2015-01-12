require 'spec_helper'

require 'tmpdir'

describe SecureArchive do
  it 'has a version number' do
    expect(SecureArchive::VERSION).not_to be nil
  end

  describe 'processes a tree of files' do
    before do
      @source_dir = Pathname.new(Dir.mktmpdir)
      @archive_dir = Pathname.new(Dir.mktmpdir)
    end

    after do
      FileUtils.remove_entry_secure(@source_dir)
      FileUtils.remove_entry_secure(@archive_dir)
    end

    it 'copies new files' do
      FileUtils.touch(@source_dir + 'a')
      FileUtils.touch(@source_dir + 'b')
      FileUtils.touch(@source_dir + 'c')

      expect_any_instance_of(SecureArchive::Encryptor::Plain).to receive(:encrypt_file).with(@source_dir + 'a', @archive_dir + 'a').and_call_original
      expect_any_instance_of(SecureArchive::Encryptor::Plain).to receive(:encrypt_file).with(@source_dir + 'b', @archive_dir + 'b').and_call_original
      expect_any_instance_of(SecureArchive::Encryptor::Plain).to receive(:encrypt_file).with(@source_dir + 'c', @archive_dir + 'c').and_call_original

      archiver = SecureArchive::Archiver.new(@archive_dir)
      archiver.archive_tree(@source_dir.realpath.to_s + '/')
    end

    it 'updates changed files' do
      now = Time.now
      FileUtils.touch(@source_dir + 'a', mtime: now)
      FileUtils.touch(@source_dir + 'b', mtime: now)
      FileUtils.touch(@source_dir + 'c', mtime: now)
      FileUtils.touch(@archive_dir + 'a', mtime: now)
      FileUtils.touch(@archive_dir + 'b', mtime: now - 5)
      FileUtils.touch(@archive_dir + 'c', mtime: now + 20)

      expect_any_instance_of(SecureArchive::Encryptor::Plain).not_to receive(:encrypt_file).with(@source_dir + 'a', @archive_dir + 'a').and_call_original
      expect_any_instance_of(SecureArchive::Encryptor::Plain).to receive(:encrypt_file).with(@source_dir + 'b', @archive_dir + 'b').and_call_original
      expect_any_instance_of(SecureArchive::Encryptor::Plain).to receive(:encrypt_file).with(@source_dir + 'c', @archive_dir + 'c').and_call_original

      archiver = SecureArchive::Archiver.new(@archive_dir)
      archiver.archive_tree(@source_dir.realpath.to_s + '/')
    end

    it 'removes deleted files' do
      FileUtils.touch(@archive_dir + 'a')
      FileUtils.touch(@archive_dir + 'b')
      FileUtils.touch(@archive_dir + 'c')

      expect(FileUtils).to receive(:rm_r).with((@archive_dir + 'a').to_s).and_call_original
      expect(FileUtils).to receive(:rm_r).with((@archive_dir + 'b').to_s).and_call_original
      expect(FileUtils).to receive(:rm_r).with((@archive_dir + 'c').to_s).and_call_original

      archiver = SecureArchive::Archiver.new(@archive_dir)
      archiver.archive_tree(@source_dir.realpath.to_s + '/')
    end

    it 'creates an additional directory without trailing slash' do
      now = Time.now
      FileUtils.mkdir_p(@archive_dir + @source_dir.basename)
      FileUtils.touch(@source_dir + 'a')
      FileUtils.touch(@source_dir + 'b', mtime: now)
      FileUtils.touch(@archive_dir + @source_dir.basename + 'b', mtime: now)
      FileUtils.touch(@archive_dir + @source_dir.basename + 'c', mtime: now - 20)

      expect_any_instance_of(SecureArchive::Encryptor::Plain).to receive(:encrypt_file).with(@source_dir + 'a', @archive_dir + @source_dir.basename + 'a').and_call_original
      expect_any_instance_of(SecureArchive::Encryptor::Plain).not_to receive(:encrypt_file).with(@source_dir + 'b', @archive_dir + @source_dir.basename + 'b').and_call_original
      expect(FileUtils).to receive(:rm_r).with((@archive_dir + @source_dir.basename + 'c').to_s).and_call_original

      archiver = SecureArchive::Archiver.new(@archive_dir)
      archiver.archive_tree(@source_dir.realpath.to_s)
    end
  end
end
