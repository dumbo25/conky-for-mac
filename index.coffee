command: "echo $(curl -s http://support-sp.apple.com/sp/product?cc=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | cut -c 9-` | awk -F '<configCode>|<.configCode>' '{print $2}') $(sw_vers -productVersion) $(system_profiler SPHardwareDataType | grep 'Processor Name') $(sysctl -n hw.cpufrequency) $(sysctl -n hw.memsize)  $(sysctl -n hw.ncpu) $(ps aux  | awk 'BEGIN { sum = 0 }  { sum += $3 }; END { print sum }') $(ipconfig getifaddr en1) $(dig +short myip.opendns.com @resolver1.opendns.com) $(/usr/local/bin/ifstat -Tzb 1 1 | grep ' [0-9]' | awk '{print $11\"Kbps \" $12\"Kbps\"}') $(top -l 1 -s 0 | grep PhysMem) $(sysctl -n vm.swapusage) $(df -gH /)" 
# conky-like widget for Mac OS X, worked on 10.11.6 and Mid 2009. Modified to work on 10.12 Mid-2012
# Notes:
#   This works on my MacBook. I haven't tested on any others
#      On your MacBook, the command may return a different number of values
#      values is an array of the values output by the command
#      Adjust value's index to match your MacBook
#   don't publish your public IP 
#   Conky uses three comment delimiters: //, <!-- -->, and #
#
# Sierra changes:
#   Got new to me mac, upgraded to sierra. sar doesn’t work on sierra. install ifstat. 
#   Replace this command: sar -n DEV 1 1 2> /dev/null | awk '/en1/{x++}x==2 {print $4,$6;exit}' 
#   with ifstat command
#	https://linux.die.net/man/1/ifstat - man page
#	http://macappstore.org/ifstat/ - installation instructions
#	Sierra doesn't come with ifstat
#   Install iftstat. Open a terminal window and run the commands
#      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
#      brew install ifstat
#      # 777 is probably the wrong setting, please do the right thing
#      sudo chmod 777 /usr/local/opt
#      brew link ifstat
# print input and output in Kbps, and grab only the in and out totals
#      /usr/local/bin/ifstat -Tzb 1 1 | grep ' [0-9]' | awk '{print $11\"Kbps \" $12\"Kbps\"

#
# please enhance / simplify

refreshFrequency: 2000

style: """
    // Align contents of container
    widget-align = left

    // Position of container on desktop
    top 10px
    right 10px

    // Text settings in container
    color #fff
    font-family Helvetica Neue
    // sets color and opacity of container's background
    background rgba(#000, .2)
    padding 10px 10px 15px
    border-radius 5px

    .container
        width: 200px
        text-align: widget-align
        position: relative
        clear: both

    .stats-container
        width: 100%
        margin-bottom 5px
        border-collapse collapse

    td
        font-size: 10px
        font-weight: bold

    .widget-title
        text-align: widget-align
        font-size 10px
        text-transform uppercase
        font-weight bold

    .widget-data
        font-size 10px
        font-weight bold
        padding-left 10px

    // data to display
    .model
        font-size: 10px
        font-weight: bold
        margin: 0

    .version
        font-size: 10px
        font-weight: bold
        margin: 0

    .processor
        font-size: 10px
        font-weight: bold
        margin: 0

    .speed
        font-size: 10px
        font-weight: bold
        margin: 0

    .memory
        font-size: 10px
        font-weight: bold
        margin: 0

    .memory_used
        font-size: 10px
        font-weight: bold
        margin: 0

    .swap_used
        font-size: 10px
        font-weight: bold
        margin: 0

    .cpu_usage
        font-size: 10px
        font-weight: bold
        margin: 0

    .cpu_cores
        font-size: 10px
        font-weight: bold
        margin: 0

    .disk_avail
        font-size: 10px
        font-weight: bold
        margin: 0

    .disk_used
        font-size: 10px
        font-weight: bold
        margin: 0

    .local_ip
        font-size: 10px
        font-weight: bold
        margin: 0

    .public_ip
        font-size: 10px
        font-weight: bold
        margin: 0

    .upload
        font-size: 10px
        font-weight: bold
        margin: 0

    .download
        font-size: 10px
        font-weight: bold
        margin: 0

"""

render: -> """
    <div class="container">
        <div class="widget-title">System</div>
        <div class="widget-data"><span class='model'></span></div>
        <div class="widget-data">OS X <span class='version'></span></div>
        <div class="widget-title">CPU</div>
        <div class="widget-data">Processor: <span class='processor'></span></div>
        <div class="widget-data">Speed: <span class='speed'></span> GHz</div>
        <div class="widget-data">Cores: <span class='cpu_cores'></span></div>
        <div class="widget-data">Usage: <span class='cpu_usage'></span> %</div>
        <div class="widget-title">RAM</div>
        <div class="widget-data">Installed: <span class='memory'></span> GB</div>
        <div class="widget-data">Used: <span class='memory_used'></span></div>
        <div class="widget-data">Swap: <span class='swap_used'></span></div>
        <div class="widget-title">SSD</div>
        <div class="widget-data">Available: <span class='disk_avail'></span></div>
        <div class="widget-data">Used:      <span class='disk_used'></span></div>
        <div class="widget-title">Network</div>
        <div class="widget-data">Public IP: <span class='public_ip'></span></div>
        <div class="widget-data">Local  IP: <span class='local_ip'></span></div>
        <div class="widget-data">Download: <span class='upload'></span></div>
        <div class="widget-data">Upload: <span class='download'></span></div>   
    </div>
"""
	
update: (output, domEl) ->
	values = output.split(" ")
	model = values[0] + " " + values[1] + values[2] + " " + values[3] + " " +values[4]
	version = values[5]
	processor = values[8] + " " + values[9] + " " + values[10] 
	speed = values[11]/1000000000
	memory = values[12]/1024/1024/1024
	cpu_cores = values[13]
	cpu_usage = values[14]/cpu_cores
	local_ip = values[15]
	public_ip = values[16]
	# future: upload and download should be in MB/GB
	download = values[17]
	upload = values[18]
	# future: memory and swap used should be in GB
	memory_used = values[20]
	# skip several values
	# grab command string and execute in terminal window to determine array index
	swap_used = values[28]
	disk_avail = values[47]
	disk_used = values[48]
	div = $(domEl)

	# must add a line like the ones below for each new value	
	div.find('.model').html(model)
	div.find('.version').html(version)
	div.find('.processor').html(processor)
	div.find('.speed').html(speed)
	div.find('.memory').html(memory)
	div.find('.cpu_usage').html(cpu_usage)
	div.find('.cpu_cores').html(cpu_cores)
	div.find('.memory_used').html(memory_used)
	div.find('.swap_used').html(swap_used)
	div.find('.disk_avail').html(disk_avail)
	div.find('.disk_used').html(disk_used)
	div.find('.local_ip').html(local_ip)
	div.find('.public_ip').html(public_ip)
	div.find('.download').html(download)
	div.find('.upload').html(upload)
