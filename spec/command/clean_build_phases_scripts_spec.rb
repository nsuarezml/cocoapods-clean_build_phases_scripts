require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::CleanBuildPhasesScripts do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ clean-build-phases-scripts }).should.be.instance_of Command::CleanBuildPhasesScripts
      end
    end

    describe 'Run' do
      it 'should not fail on error' do
        # test.xcodeproj doesn't exist
        command = Command.parse(%w{ clean-build-phases-scripts --xcodeproj=test.xcodeproj })
        lambda { command.run }.should.not.raise
      end
    end
  end
end

