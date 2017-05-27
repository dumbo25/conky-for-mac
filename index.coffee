command: "echo $(sw_vers -productVersion) $(sysctl -n hw.cpufrequency) $(sysctl -n hw.memsize)  $(sysctl -n hw.ncpu) $(ps aux  | awk 'BEGIN { sum = 0 }  { sum += $3 }; END { print sum }') $(ipconfig getifaddr en1) $(dig +short myip.opendns.com @resolver1.opendns.com) $(sar -n DEV 1 1 2> /dev/null | awk '/en1/{x++}x==2 {print $4,$6;exit}') $(top -l 1 -s 0 | grep PhysMem) $(sysctl -n vm.swapusage) $(df -gH /)" 
# conky-like widget for Mac OS X, works on 10.11.6
# don't publish your public IP
# please enhance

refreshFrequency: 2000

# Note: three comment delimiters are used: //, <!-- -->, and #

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
    .version
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
        <!-- I use following computer, change to yours -->
        <div class="widget-data">MacBook Pro Mid-2009</div>
        <div class="widget-data">OS X <span class='version'></span></div>
        <div class="widget-title">CPU</div>
        <!-- Future: Rather than hardcoding parse: sysctl -n machdep.cpu.brand_string -->
        <!-- use: system_profiler SPHardwareDataType | grep "Processor Name" -->
        <div class="widget-data">Processor: Core2 Duo P7550</span></div>
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

  version = values[0]
  speed = values[1]/1000000000
  memory = values[2]/1024/1024/1024
  cpu_cores = values[3]
  cpu_usage = values[4]/cpu_cores
  local_ip = values[5]
  public_ip = values[6]
  # future: upload and download should be in MB/GB
  download = values[7]
  upload = values[8]
  # future: memory and swap used should be in GB
  memory_used = values[10]
  # skip several values
  # grab command string and execute in terminal window to determine array index
  swap_used = values[18]
  disk_avail = values[37]
  disk_used = values[38]
  div     = $(domEl)

  # must add a line like the ones below for each new value  
  div.find('.version').html(version)
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
