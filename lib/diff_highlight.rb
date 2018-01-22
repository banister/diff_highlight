require "diff_highlight/version"
require "coderay"

class DiffHighlight
  Signal.trap("PIPE") { exit(0) }

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
        flush_buffer
        @language = type_from_filename(line.split.last)
      end

      if line =~ /^\+[^\+]/
        write_added_line(line)
      else
        flush_buffer
        write_other_line(line)
      end
    end

    flush_buffer
  end

  private

  def type_from_filename(filename, default = :unknown)
    _, language = EXTENSIONS.find do |k, _|
      k.any? { |ext| ext == File.extname(filename) }
    end || FILES.find do |k, _|
      k.any? { |file_name| file_name == File.basename(filename) }
    end

    language || default
  end

  def flush_buffer
    if !@buffer.empty?
      write(CodeRay.highlight(@buffer, @language, {}, :term))
      @buffer.clear
    end
  end

  def write_added_line(line)
    if @language == :unknown
      write(green(line))
    else
      @buffer += line
    end
  end

  # when a line is not an addition (e.g begins with a +)
  def write_other_line(line)
    if line =~ /^-/
      write(red(line))
    else
      write(line)
    end
  end

  def write(str)
    $stdout.write(str) unless $stdout.closed?
  end

  def red(str)
    "\e[31m#{str}\e[0m"
  end

  def green(str)
    "\e[32m#{str}\e[0m"
  end
end
