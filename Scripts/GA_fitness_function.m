function cost = GA_fitness_function(x)

    % Extract PID gains
    Kp = x(1);
    Ki = x(2);
    Kd = x(3);

    % Define plant (DC motor)
    G = tf(44.99, [1 44.98 78.962 0]);

    % PID controller
    C = pid(Kp, Ki, Kd);

    % Closed-loop system
    T = feedback(C * G, 1);

    % Step response
    [y, t] = step(T, 10);

    % Tracking error
    e = 1 - y;

    % ITAE performance index
    ITAE = trapz(t, t .* abs(e));

    % Overshoot penalty
    overshoot = max(y) - 1;
    penalty = 100 * max(0, overshoot);

    % Final cost
    cost = ITAE + penalty;

end