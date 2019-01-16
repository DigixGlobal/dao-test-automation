#!/usr/bin/python
import subprocess
import sys


class CustomRunner:

    base_url = "LOCAL"
    browser = "chrome"
    test_type="smoke"
    severity = "ALL"
    exitOnfailure = "yes"
    runner = "robot"

    def enter_base_url(self):
        print "############################################################"
        print "#   STEP 1: Setup Environment                              #"
        print "############################################################"
        print "1. Local"
        print "2. Kovan"

        while True:
            choice = raw_input("Enter Environment (default %s): " % self.base_url)
            if choice == '':
                break
            if choice == '1':
                self.base_url = 'LOCAL'
                break
            if choice == '2':
                self.base_url = 'KOVAN'
                break
        print "Tests will be run against domain: %s" % self.base_url

    def choose_browser(self):
        print "############################################################"
        print "#   STEP 2: Select Browser                                 #"
        print "############################################################"
        print "1. chrome (make sure chromedriver is configured)"
        print "2. firefox"

        while True:
            choice = raw_input("Enter number (default %s): " % self.browser)
            if choice == '':
                break
            if choice == '1':
                self.browser = 'chrome'
                break
            if choice == '2':
                self.browser = 'firefox'
                break
        print "Tests will be run in browser: %s" % self.browser

    def choose_test_type(self):
        print "############################################################"
        print "#   STEP 3: Choose Testing Type                            #"
        print "############################################################"
        print "1. smoke"
        print "2. sanity"
        print "3. regression"

        while True:
            choice = raw_input("Enter number (default %s): " % self.test_type)
            if choice == '':
                break
            if choice == '1':
                self.test_type = 'smoke'
                break
            if choice == '2':
                self.test_type = 'sanity'
                break
            if choice == '3':
                self.test_type = 'regression'
                break    
        print "Test Type: %s" % self.test_type

    def exit_on_failure(self):
        print "############################################################"
        print "#   STEP 4: Exit When Any Test Failed?                     #"
        print "############################################################"
        print "1. Yes"
        print "2. No"

        while True:
            choice = raw_input("Exit On Any Test Failed (default %s): " % self.exitOnfailure)
            if choice == '':
                self.exitOnfailure = '--exitonfailure'
                break
            if choice == '1':
                self.exitOnfailure = '--exitonfailure'
                break
            if choice == '2':
                self.exitOnfailure = ''
                break
        print "Tests will be exit immediately: %s" % self.exitOnfailure

    def interpreter_runnner(self):
        print "############################################################"
        print "#   STEP 4: Runner?                                        #"
        print "############################################################"
        print "1. robot"
        print "2. pybot"
        print "3. pabot (run 2 test suite in parallel)"

        while True:
            choice = raw_input("what runner you want to use? (default %s): " % self.runner)
            if choice == '':
                break
            if choice == '1':
                self.runner = 'robot'
                break
            if choice == '2':
                self.runner = 'pybot'
                break    
            if choice == '3':
                self.runner = 'pabot --processes 2'
                break
        print "Tests will be runned on: %s" % self.runner

    def print_array_of_choices(self, choices):
        for choice in choices:
            print "%d. %s" % (choices.index(choice)+1, choice)

    def generate_command_string(self):
        cmd = '%s ' % self.runner
        cmd += '--variable ENVIRONMENT:%s ' % self.base_url
        cmd += '--variable BROWSER:%s ' % self.browser
        cmd += '--include %s ' % (self.test_type)
        cmd += '%s ' % self.exitOnfailure
        cmd += '--outputdir Results/ '
        cmd += '.'
        return cmd

    def run_rf(self):
        cmd = self.generate_command_string()
        print "Script is now running..."
        print "############################################################"
        print cmd
        print "############################################################"
        process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE
                                   )
        for c in iter(lambda: process.stdout.read(1), ''):
            sys.stdout.write(c)
        for c in iter(lambda: process.stderr.read(1), ''):
            sys.stdout.write(c)

if __name__ == "__main__":
    app = CustomRunner()
    app.enter_base_url()
    app.choose_browser()
    app.choose_test_type()
    app.exit_on_failure()
    app.interpreter_runnner()
    app.run_rf()
