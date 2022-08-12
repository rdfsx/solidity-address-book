import { ContractReceipt } from 'ethers'
import { ethers } from 'hardhat'
import { expect } from 'chai'

describe('SimpleAddressBook contract tests', () => {
  before(async function () {
    this.accounts = await ethers.getSigners()
    this.owner = this.accounts[0]
    this.user = this.accounts[1]
    this.factory = await ethers.getContractFactory('SimpleAddressBook')
    this.contract = await this.factory.deploy()
  })

  describe('Functionality', function () {
    const alias = 'test'
    const address = '0xb794f5ea0ba39494ce839613fffba74279579268'

    it('should create address book', async function () {
      const tx = await this.contract.createAddressBook({
        value: ethers.utils.parseEther('1'),
      })
      const receipt: ContractReceipt = await tx.wait()
      expect(receipt.events?.map((x) => x.event)).to.include(
        'AddressBookCreated'
      )
    })

    it('should add alias', async function () {
      const tx = await this.contract.addAlias(address, alias)
      const receipt: ContractReceipt = await tx.wait()
      expect(receipt.events?.map((x) => x.event)).to.include('AliasAdded')
    })

    it('should get alias', async function () {
      const tx = await this.contract.getAlias(address)
      expect(tx).to.equal(alias)
    })

    it('should delete alias', async function () {
      const tx = await this.contract.removeAddress(address)
      const receipt: ContractReceipt = await tx.wait()
      expect(receipt.events?.map((x) => x.event)).to.include('AliasRemoved')
      expect(await this.contract.getAlias(address)).to.equal('')
    })
  })
})
