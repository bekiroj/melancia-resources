--don�t change
newlightstate = 0

--time to change the status(red,yellow,green) of the trafficlights, 25sec
changetime=25000
--out of order counter don�t change
ocounter =0
ostop = 5000 -- of change the trafficlights to be out of order, can change
--don�t change
change=Timer
changeback=Timer
otimer=Timer

--10min then change back to normal
backtonormaltime=1000*60*10


function main()
setTrafficLightState(0)
change= setTimer(changestate,changetime,0)
end
addEventHandler ( "onResourceStart", getRootElement(), main )



function handleTrafficLightsOutOfOrder()
    -- See if the lights are currently off
    local lightsOff = getTrafficLightState() == 9

    if lightsOff then
        -- If they're off, turn them on
        setTrafficLightState(6)
    else
        -- If they're on, turn them off
        setTrafficLightState(9)
    end

end

function backtonormal()

	setTrafficLightState(0)
	setTimer(changestate,changetime,0)
	killTimer(otimer)
end



function changestate()
outoforder =math.random(0,100)
-- random to set the state from the trafficlights to out of order
if outoforder==25 then
	killTimer(change)
	ocounter =0
	setTrafficLightState(9)
	otimer=setTimer(handleTrafficLightsOutOfOrder,500,0)
	setTimer(backtonormal,backtonormaltime,1)
end

	if ocounter ==ostop then
	killTimer(change)
	ocounter =0
	setTrafficLightState(9)
	otimer=setTimer(handleTrafficLightsOutOfOrder,500,0)
	setTimer(backtonormal,backtonormaltime,1)
	end

		if newlightstate==0 then newlightstate=1
			elseif
			newlightstate==1 then newlightstate=4
				elseif
				newlightstate==4 then newlightstate=3
					elseif
					newlightstate==3 then newlightstate=4
					killTimer(change)
					changeback =setTimer(changestateback,changetime,0)

		end

	ocounter=ocounter+1
	setTrafficLightState(newlightstate)
	setTrafficLightsLocked ( true )
end

function changestateback()

outoforder =math.random(0,100)
-- random to set the state from the trafficlights to out of order
if outoforder==25 then
	killTimer(changeback)
	ocounter =0
	setTrafficLightState(9)
	otimer=setTimer(handleTrafficLightsOutOfOrder,500,0)
	setTimer(backtonormal,backtonormaltime,1)
end

	if ocounter ==  ostop then
	killTimer(changeback)
	ocounter =0
	setTrafficLightState(9)
	setTimer(handleTrafficLightsOutOfOrder,500,0)
	setTimer(backtonormal,backtonormaltime,1)
	end

		if newlightstate==3 then newlightstate=4
			elseif
			newlightstate==4 then newlightstate=1
				elseif
				newlightstate==1 then newlightstate=0
				killTimer(changeback)
				change =setTimer(changestate,changetime,0)
		end

	ocounter=ocounter+1
	setTrafficLightState(newlightstate)
	setTrafficLightsLocked ( true )
end
