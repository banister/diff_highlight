require "diff_highlight/version"
require 'coderay'

class DiffHighlight
  EXTENSIONS = {
    %w(.py)        => :python,
    %w(.js)        => :javascript,
    %w(.css)       => :css,
    %w(.xml)       => :xml,
    %w(.php)       => :php,
    %w(.html)      => :html,
    %w(.diff)      => :diff,
    %w(.java)      => :java,
    %w(.json)      => :json,
    %w(.c .h)      => :c,
    %w(.rhtml)     => :rhtml,
    %w(.yaml .yml) => :yaml,
    %w(.cpp .hpp .cc .h .cxx) => :cpp,
    %w(.rb .ru .irbrc .gemspec .pryrc .rake) => :ruby,
  }

  FILES = {
    %w(Gemfile Rakefile Guardfile Capfile) => :ruby
  }

  def initialize
    @buffer = ""
  end

  def execute
    ARGF.each_line do |line|
      if line =~ /^diff --git/
        @language = type_from_filename(line.split.last)
      end

      if line =~ /^\+/
        @buffer += line
      else
        highlight_write(CodeRay.highlight(@buffer, @language, {}, :term))
        @buffer.clear
        if line =~ /^-/
          $stdout.write(red(line))
        else
          $stdout.write(line)
        end
      end
    end
  end

  private

  def type_from_filename(filename, default = :unknown)
    _, language = EXTENSIONS.find do |k, _|
      k.any? { |ext| ext == File.extname(filename) }
    end || FILES.find do |k, _|
      k.any? { |file_name| file_name == File.basename(filename) }
    end

    language || :txt
  end

  def highlight_write(str)
    $stdout.write(CodeRay.highlight(@buffer, @language, {}, :term))
  end

  def red(str)
    "\e[31m#{str}\e[0m"
  end
end
