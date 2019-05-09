#!/usr/bin/python
import subprocess
import sys


class CustomRunner:
    #contants
    environment = "LOCAL"
    browser = "Chrome"
    exitOnfailure = "yes"
    runner = "robot"
    wallet = "json"
    LIST_OF_TAGS = [
        "DaoKYCETest", "ForumAdminETest", "DaoOneMilestoneETest", "DaoTwoMilestonesETest", "DaoMetamaskWalletETest", 
        "DaoSpecialProposalTest", "DaoCreateEditPreviewAbortTest", "DaoAddDocsClaimFailedTest", "DaoCreateWalletRedeemBageTest",
        "DaoCreateProposalMetamaskTest","DaoChangeFundingTest", 
        "DaoProfileOverviewTest", "DaoSideNavMenuTest","DaoLikeModuleTest", "DaoCommentModuleTest", 
        "DaoSetUsernameEmailTest","DaoClaimRewardTest", "DaoRedeemBadgeTest", "DAOUnlockDGDTest", 
        "DaoKYCAdminTest", "DaoKYCSubmissionTest", "DaoCreateNewWalletTest",
        "regression", "smoke", "sanity","endtoend",
    ]

    def enter_base_url(self):
        print "############################################################"
        print "#   STEP 1: Setup Environment                              #"
        print "############################################################"
        print "1. Local"
        print "2. Kovan"

        while True:
            choice = raw_input("Enter Environment (default %s): " % self.environment)
            if choice == '':
                break
            if choice == '1':
                self.environment = 'LOCAL'
                break
            if choice == '2':
                self.environment = 'KOVAN'
                break
        print "Tests will be run against domain: %s" % self.environment

    def choose_browser(self):
        print "############################################################"
        print "#   STEP 2: Select Browser                                 #"
        print "############################################################"
        print "1. chrome (make sure chromedriver is configured)"
        print "2. Headless Chrome"

        while True:
            choice = raw_input("Enter number (default %s): " % self.browser)
            if choice == '':
                break
            if choice == '1':
                self.browser = 'Chrome'
                break
            if choice == '2':
                self.browser = 'headlesschrome'
                break
        print "Tests will be run in browser: %s" % self.browser

    def choose_test_suite(self):
        print "############################################################"
        print "#   STEP 3: Choose Test Suite / Tag                        #"
        print "############################################################"

        while True:
            self.print_array_of_choices(self.LIST_OF_TAGS)
            choice = raw_input("Enter number: ")
            try:
                choice_int = int(choice)
            except (RuntimeError, TypeError, NameError, ValueError):
                continue
            if choice_int > 0 and choice_int <= (len(self.LIST_OF_TAGS)):
                self.test_suite = self.LIST_OF_TAGS[choice_int-1]
                break
        print "Test Suite / Tag selected: %s" % self.test_suite
    
    def wallet_type(self):
        print "############################################################"
        print "#   STEP 4: Select Wallet Type                             #"
        print "############################################################"
        print "1. json"
        print "2. metamask"

        while True:
            choice = raw_input("Enter number (default %s): " % self.wallet)
            if choice == '':
                break
            if choice == '1':
                self.wallet = 'json'
                break
            if choice == '2':
                self.wallet = 'metamask'
                break
        print "Tests will be run in browser: %s" % self.wallet

    def exit_on_failure(self):
        print "############################################################"
        print "#   STEP 5: Exit When Any Test Failed?                     #"
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
        print "#   STEP 6: Runner?                                        #"
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
                self.runner = 'pabot --processes 4'
                break
        print "Tests will be runned on: %s" % self.runner

    def print_array_of_choices(self, choices):
        for choice in choices:
            print "%d. %s" % (choices.index(choice)+1, choice)

    def generate_command_string(self):
        cmd = '%s ' % self.runner
        cmd += '--variable ENVIRONMENT:%s ' % self.environment
        cmd += '--variable BROWSER:%s ' % self.browser
        cmd += '--include %s ' % self.test_suite
        cmd += '--variable WALLET:%s ' % self.wallet
        cmd += '%s ' % self.exitOnfailure
        cmd += '--outputdir Results/%s ' % self.test_suite
        cmd += '.'
        return cmd

    def run_rf(self):
        cmd = self.generate_command_string()
        print "Script is now running..."
        print "############################################################"
        print cmd
        print "############################################################"
        process = subprocess.Popen(
            cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        for c in iter(lambda: process.stdout.read(1), ''):
            sys.stdout.write(c)
        for c in iter(lambda: process.stderr.read(1), ''):
            sys.stdout.write(c)

if __name__ == "__main__":
    app = CustomRunner()
    app.enter_base_url()
    app.choose_browser()
    app.choose_test_suite()
    app.wallet_type()
    app.exit_on_failure()
    app.interpreter_runnner()
    app.run_rf()
