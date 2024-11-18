module Boot
  module_function
  def init
    # 判断 .env 文件是否存在, 不存在则创建
    unless File.exist?(".env")
      File.open(".env", "w") do |f|
        f.write("LISA_ACCESS_TOKEN=<Lisa access token, visit: https://platform.listenai.com/>\n")
        f.write("JUDGE_ACCCESS_TOKEN=<Judge access token, visit: https://platform.listenai.com/>\n")

        f.write("; if you are using a different typechat endpoint, please fill in the following line\n")
        f.write("; LISA_TYPECHAT_ENDPOINT=https://lisa-typechat.listenai.com\n")

        f.write("; if you are using a different LLM endpoint, please fill in the following line\n")
        f.write("; LISA_LLM_URI_BASE=https://api.listenai.com\n")

        f.write("; if you are using a different JUDGE LLM endpoint, please fill in the following line\n")
        f.write("; JUDGE_LLM_URI_BASE=https://api.listenai.com\n")
      end

      puts "Created .env file, please fill in the necessary information."
    end

    
  end
end