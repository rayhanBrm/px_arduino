---@diagnostic disable: need-check-nil

local port = serial:find_serial(0) -- find_serial(0) = port TELEM2, find_serial(1) = port GPS2

if not port then
    gcs:send_text(0, "PORT SALAH") -- jika port tidak terhubung dengan benar maka masuk kondisi ini
    return
end

port:begin(57600) -- baudrate harus sama antara pixhawk dan arduino
port:set_flow_control(0)

function update() -- fungsi untuk update kondisi yang akan dipanggil berkali kali untuk mengupdate data batre yang dikirim dari arduino
    if port:available() then
        local data = ""
        local byte = port:read()

        while byte and byte ~= -1 do
            -- Ensure the byte is within valid ASCII range
            if byte >= 0 and byte <= 255 then
                data = data .. string.char(byte)
            end
            byte = port:read()
        end
    
        -- gcs:send_text(0, "Data received: " .. data)  -- Debugging information

        if #data > 0 then
            local voltage_str = data:match("%d+%.%d+") -- matching data bentuk float di arduino untuk diterima

            if voltage_str then  -- Ensure voltage_str is not nil
                local voltage = tonumber(voltage_str)

                if voltage then
                    gcs:send_text(0, string.format("Voltage: %.2f", voltage))
                else
                    gcs:send_text(0, "Invalid voltage value")
                end
            else
                gcs:send_text(0, "No voltage string found")
            end
        --else
          --  gcs:send_text(0, "TIDAK ADA DATA") --digunakan untuk debugging
        end    
    else
        gcs:send_text(0, "No data available from port")
    end
    return update, 1000
end

return update()
