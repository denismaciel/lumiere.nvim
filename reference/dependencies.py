import os
import subprocess
import snowsaw


class Dependencies(snowsaw.Plugin):
    """
    plugin to install dependencies for the current project.
    """

    _directive = "dependencies"
    _executable = os.environ.get("SHELL")

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('Plugin "Dependency" cannot handle directive')
        return self._process_dependencies(data)

    def _check_dependency(self, dependency):
        with open(os.devnull, "w") as devnull:
            stdin = stdout = stderr = devnull

            check = None
            package_type = None
            name = dependency["name"]
            cmd = dependency["cmd"]
            skip = dependency.get("skip", False)

            if skip == True:
                self._log.lowinfo("dependency '{}' skipped".format(name))
                return True

            if "brew cask" in cmd:
                check = "brew cask ls --versions {}".format(name)
                package_type = "brew cask"

            if check is None:
                check = cmd
                package_type = "shell"

            process = subprocess.Popen(
                check,
                executable=self._executable,
                shell=True,
                stdin=stdin,
                stdout=stdout,
                stderr=stderr,
            )

            return process.wait() == 0

    def _process_dependencies(self, dependencies):
        return all(
            self._check_dependency(dependency)
            for dependency in dependencies
        )
