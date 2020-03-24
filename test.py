from selenium import webdriver

class Bot():
    def __init__(self):
        self.driver = webdriver.Chrome()

    def insertUsers(self):
        self.driver.get('http://localhost:8984/bj/setup')

        buttonSubmit = self.driver.find_element_by_xpath('/html/body/div[2]/form/input')

        dummyPlayerName1 = 'Lorenzo'
        dummyPlayerBalance1 = 111
        dummyPlayerName2 = 'Ikbal'
        dummyPlayerBalance2 = 2222
        dummyPlayerName3 = 'Patrick'
        dummyPlayerBalance3 = 333
        dummyPlayerName4 = 'Markus'
        dummyPlayerBalance4 = 1111
        dummyPlayerName5 = 'Mario'
        dummyPlayerBalance5 = 444

        dummyMaxBet = 3333
        dummyMinBet = 22

        inputNameFeld1 = self.driver.find_element_by_xpath('//*[@id="inputname1"]')
        inputBalanceFeld1 = self.driver.find_element_by_xpath('//*[@id="inputbalance1"]')

        inputNameFeld2 = self.driver.find_element_by_xpath('//*[@id="inputname2"]')
        inputBalanceFeld2 = self.driver.find_element_by_xpath('//*[@id="inputbalance2"]')

        inputNameFeld3 = self.driver.find_element_by_xpath('//*[@id="inputname3"]')
        inputBalanceFeld3 = self.driver.find_element_by_xpath('//*[@id="inputbalance3"]')

        inputNameFeld4 = self.driver.find_element_by_xpath('//*[@id="inputname4"]')
        inputBalanceFeld4 = self.driver.find_element_by_xpath('//*[@id="inputbalance4"]')

        inputNameFeld5 = self.driver.find_element_by_xpath('//*[@id="inputname5"]')
        inputBalanceFeld5 = self.driver.find_element_by_xpath('//*[@id="inputbalance5"]')

        inputMaxBet = self.driver.find_element_by_xpath('//*[@id="maxBet"]')
        inputMinBet = self.driver.find_element_by_xpath('//*[@id="minBet"]')

        inputNameFeld1.send_keys(dummyPlayerName1)
        inputBalanceFeld1.send_keys(dummyPlayerBalance1)

        inputNameFeld2.send_keys(dummyPlayerName2)
        inputBalanceFeld2.send_keys(dummyPlayerBalance2)

        inputNameFeld3.send_keys(dummyPlayerName3)
        inputBalanceFeld3.send_keys(dummyPlayerBalance3)

        inputNameFeld4.send_keys(dummyPlayerName4)
        inputBalanceFeld4.send_keys(dummyPlayerBalance4)

        inputNameFeld5.send_keys(dummyPlayerName5)
        inputBalanceFeld5.send_keys(dummyPlayerBalance5)

        inputMaxBet.send_keys(dummyMaxBet)
        inputMinBet.send_keys(dummyMinBet)

        buttonSubmit.click()

bot = Bot()
bot.insertUsers()