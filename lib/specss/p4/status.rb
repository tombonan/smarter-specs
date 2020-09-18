module Specss
  module P4
    #
    # A class for tracking git status
    class Status
      include Enumerable

      def initialize(base)
        @base = base
        construct_status
      end

      #
      # Returns an Enumerable containing files that have been edited
      # or opened for edit.
      #
      # @return [Enumerable]
      def changed
        @files.select { |_k, f| f.action == 'edit' }
      end

      #
      # Determines whether the given file has been changed.
      # File path starts at p4 working directory
      #
      # @param file [String] The name of the file.
      # @example Check if p4/lib.rb has changed.
      #     changed?('p4/lib.rb')
      # @return [Boolean]
      def changed?(file)
        changed.member?(file)
      end

      #
      # Returns an Enumerable containing files that have been added.
      # File path starts at p4 working directory
      #
      # @return [Enumerable]
      def added
        @files.select { |_k, f| f.action == 'add' }
      end

      #
      # Determines whether the given file has been
      # added or opened to add to the repository
      # File path starts at p4 working directory
      #
      # @param file [String] The name of the file.
      # @example Check if p4/lib.rb is added.
      #     added?('p4/lib.rb')
      # @return [Boolean]
      def added?(file)
        added.member?(file)
      end

      #
      # Returns an Enumerable containing files that have been deleted.
      # File path starts at p4 working directory
      #
      # @return [Enumerable]
      def deleted
        @files.select { |_k, f| f.action== 'delete' }
      end

      #
      # Determines whether the given file has been deleted
      # or open to delete from the repository
      # File path starts at p4 working directory
      #
      # @param file [String] The name of the file.
      # @example Check if p4/lib.rb is deleted.
      #     deleted?('p4/lib.rb')
      # @return [Boolean]
      def deleted?(file)
        deleted.member?(file)
      end

      def pretty
        out = ''
        each do |file|
          out << pretty_file(file)
        end
        out << "\n"
        out
      end

      def pretty_file(file)
        <<-FILE.strip_heredoc
        #{file.path}
        \taction   #{file.action}
        \tdepot  //#{file.depot}
      FILE
      end

      # enumerable method

      def [](file)
        @files[file]
      end

      def each(&block)
        @files.values.each(&block)
      end

      # subclass that does heavy lifting
      class StatusFile
        attr_accessor :path, :action, :depot

        def initialize(base, hash)
          @base = base
          @path = hash[:path]
          @action = hash[:action]
          @depot = hash[:depot]
        end
      end

      private

      def construct_status
        @files = @base.lib.all_files

        @files.each do |k, file_hash|
          @files[k] = StatusFile.new(@base, file_hash)
        end
      end
    end
  end
end
