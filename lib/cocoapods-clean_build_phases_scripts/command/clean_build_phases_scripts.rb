module Pod
  class Command
    class CleanBuildPhasesScripts < Command
      self.summary = "Remove input/output files from 'Copy Pod Resources' build phases script"
      self.description = <<-DESC
        Remove input/output files from 'Copy Pod Resources' build phases script.
      DESC

      self.arguments = [ CLAide::Argument.new('xcodeproj', false) ]

      def self.options
        [ ['--xcodeproj=PATH', '.xcodeproj path'] ].concat(super)
      end

      def initialize(argv)
        @xcodeproj_path = argv ? argv.option('xcodeproj') : nil
        super
      end

      def validate!
        super
      end

      def run
        if @xcodeproj_path 
          clean(@xcodeproj_path)
        else
          projects = Dir.glob("**/*.xcodeproj")
          projects.each do |project_path|
            puts "[cocoapods-clean_build_phases_scripts] Checking project #{project_path}"
            clean(project_path)
          end
        end
      end

      def clean(project_path)
        begin
          xcode_project = Xcodeproj::Project.open(project_path)
          xcode_project.targets.each do |target|
            phase_name = '[CP] Copy Pods Resources'
            target.shell_script_build_phases.select { |phase| phase.name && phase.name.end_with?(phase_name) }.each do |phase|
                  puts "[cocoapods-clean_build_phases_scripts] Removing input/output paths from script '#{phase.name}' in target '#{target.name}'"
                  phase.input_paths = []
                  phase.output_paths = []
            end
          end
          xcode_project.save
        rescue Exception => e
          puts "[cocoapods-clean_build_phases_scripts] Can't remove input/output paths in project #{project_path}."
          puts "[cocoapods-clean_build_phases_scripts] Error: #{e}"
        end
      end

    end
  end
end
