#if all engines of drone are at power 50, then it is hovering
#if engines' power are at >50, then it will be going up, else going down
#drone can move only in one direction at a time

class Drone

    def initialize()
        @engines = [
            #front left 
            {power: 0, status: 'off'}, 
            #front right
            {power: 0, status: 'off'},
            #back right 
            {power: 0, status: 'off'}, 
            #back left
            {power: 0, status: 'off'}
        ]
        @gyroscope = {
            x: 0,
            y: 0,
            z: 0
        }
        @orientation_sensor = {
            pitch: 0,
            roll: 0
        }
        puts "drone initialized"
    end

    def take_off
        @engines.each do |e|
            e[:status] = 'on'
        end

        move_up

        stabilize
    end

    def move_forward
        if engines_on?
            @engines[0][:power] = 40
            @engines[1][:power] = 40
            @engines[2][:power] = 60
            @engines[3][:power] = 60
            @gyroscope[:x] = 10
            @orientation_sensor[:pitch] = 1
        end  
    end

    def move_back
        if engines_on?
            @engines[0][:power] = 60
            @engines[1][:power] = 60
            @engines[2][:power] = 40
            @engines[3][:power] = 40
            @gyroscope[:x] = -10
            @orientation_sensor[:pitch] = -1     
        end
    end

    def move_up
        if engines_on?
            @engines[0][:power] = 60
            @engines[1][:power] = 60
            @engines[2][:power] = 60
            @engines[3][:power] = 60
            @gyroscope[:z] = 10
        end
    end

    def move_down
        if engines_on?
            @engines[0][:power] = 40
            @engines[1][:power] = 40
            @engines[2][:power] = 40
            @engines[3][:power] = 40
            @gyroscope[:z] = -10
        end
    end

    def move_right
        if engines_on?
            @engines[0][:power] = 60
            @engines[1][:power] = 40
            @engines[2][:power] = 40
            @engines[3][:power] = 60
            @gyroscope[:y] = 10
        end
    end

    def move_left
        if engines_on?
            @engines[0][:power] = 40
            @engines[1][:power] = 60
            @engines[2][:power] = 60
            @engines[3][:power] = 40
            @gyroscope[:y] = -10
        end
    end

    def stabilize
        if engines_on?
            @engines.each do |e|
                e[:power] = 50
            end
            @gyroscope[:x] = 0
            @gyroscope[:y] = 0
            @gyroscope[:z] = 0
            @orientation_sensor[:x] = 0
            @orientation_sensor[:y] = 0
        else
            puts "The drone is off. Take off first."
        end
    end

    def status
        if engines_on?
            if @orientation_sensor[:pitch] > 0
                puts "The drone is moving forward"
             end
             if @orientation_sensor[:pitch] < 0
                puts "the drone is moving back"
             end
             if @orientation_sensor[:roll] > 0
                puts "The drone is moving right"
             end
             if @orientation_sensor[:roll] < 0
                puts "The drone is moving left"
             end
             if @orientation_sensor[:roll] == 0 && @orientation_sensor[:pitch] == 0
                puts "The drone is hovering"
             end  
        else
            puts "The drone is off. Take off first."
        end
    end

    def land
        stabilize

        move_down

        @engines.each do |e|
            e[:power] = 0
            e[:status] = 'off'
        end
    end

    def engines_on?
        @engines[0][:status] == 'on' && @engines[1][:status] == 'on' && @engines[2][:status] == 'on'  && @engines[3][:status] == 'on' 
    end

end

drone = Drone.new

while true
    puts "Enter command: take_off, status, move_f, move_b, move_u, move_d, move_r, move_l, stabilize or land"
    command = gets.chomp.to_s
    
    case command
    when 'take_off'
      drone.take_off
    when 'status'
      drone.status
    when 'move_f'
      drone.move_forward
    when 'move_b'
      drone.move_back
    when 'move_u'
        drone.move_up
    when 'move_d'
        drone.move_down 
    when 'move_r'
        drone.move_right
    when 'move_l'
        drone.move_left     
    when 'land'
        drone.land   
    when 'stabilize'
        drone.stabilize
    else
      "#{command} is an invalid command. Try again"
    end
end