# Defines HTTY::CLI::Commands::ReloadCommands

module HTTY; end

class HTTY::CLI; end

module HTTY::CLI::Commands; end

# Encapsulates the _reload-commands_ command.
class HTTY::CLI::Commands::ReloadCommands < HTTY::CLI::Command

  # Reloads libraries in the commands directory
  def perform
    Dir.glob "#{working_directory}/*.rb" do |command|
      load command
    end
  end

  private
  def working_directory
    File.dirname __FILE__
  end

end
