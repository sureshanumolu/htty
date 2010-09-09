# Defines HTTY::CLI::Commands::OpenResponse.

require 'rubygems'
require File.expand_path("#{File.dirname __FILE__}/../../no_response_error")
require File.expand_path("#{File.dirname __FILE__}/../command")
require File.expand_path("#{File.dirname __FILE__}/body_request")
require File.expand_path("#{File.dirname __FILE__}/headers_response")
require File.expand_path("#{File.dirname __FILE__}/status")

module HTTY; end

class HTTY::CLI; end

module HTTY::CLI::Commands; end

# Encapsulates the _open-response_ command.
class HTTY::CLI::Commands::OpenResponse < HTTY::CLI::Command

  # Returns the name of a category under which help for the _response_ command
  # should appear.
  def self.category
    'Inspecting Responses'
  end

  # Returns the string used to invoke the _open-response_ command from the
  # command line.
  def self.command_line
    'open[-response]'
  end

  # Returns the help text for the _open-response_ command.
  def self.help
    'Opens the response in the browser'
  end

  # Returns the extended help text for the _open-response_ command.
  def self.help_extended
    'Opens the saved response in your default browser'
  end

  # Returns related command classes for the _open-response_ command.
  def self.see_also_commands
    [HTTY::CLI::Commands::HeadersResponse,
     HTTY::CLI::Commands::Status,
     HTTY::CLI::Commands::BodyRequest]
  end

  # Performs the _open-response_ command.
  def perform
    unless (response = session.last_response)
      raise HTTY::NoResponseError
    end
    unless (body = response.body).strip.empty?
      open(body)
    end
    self
  end

  private

  def open(body)
    require "launchy"
    page = render_page(body)
    Launchy::Browser.run(page.path)
    sleep 1
    File.delete(page.path)
  rescue LoadError
    warn "Sorry, you need to install launchy to open pages: `gem install launchy`"
  end

  def render_page(body)
    name = "htty-#{Time.new.strftime("%Y%m%d%H%M%S")}.html"
    File.open(name, 'w') { |f| f << body }
  end

end
