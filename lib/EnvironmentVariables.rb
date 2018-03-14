module LitleOnline
  class EnvironmentVariables
    def initialize
      #load configuration data
      @user = ''
      @password = ''
      @currency_merchant_map=''
      @default_report_group='Default Report Group'
      @url=''
      @proxy_addr=''
      @proxy_port=''
      @sftp_username=''
      @sftp_password=''
      @sftp_url=''
      @fast_url=''
      @fast_port=''
      @printxml=false
      @timeout=65
      @deleteBatchFiles = false
      @useEncryption = false
      @vantivPublicKeyID = ''
      @passphrase = ''
    end
  end
end