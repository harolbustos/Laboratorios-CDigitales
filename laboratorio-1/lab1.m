%% Actividad previa

% 1) Parametros de la señal sinusoidal m(t)
periodo_muestreo_simulacion = 10e-6; %parametro ajustable, simulando una señal análoga
tiempo = 0:periodo_muestreo_simulacion:1e-3; % vector de tiempo hasta 1 milisegundo
fm = 1000; %frecuencia de la sinusoidal 
A = 1; %amplitud de la sinusoidal
m = A*sin(2*pi*fm*tiempo); %señal sinusoidal m(t)

% 2) Parametros para la modulación PAM natural (PAMn)
frecuencia_muestreo_PAMn = 5000;
periodo_muestreo_PAMn = 1/frecuencia_muestreo_PAMn;
ciclo_trabajo_natural = 0.2;
tao_natural = ciclo_trabajo_natural/frecuencia_muestreo_PAMn;

%Creación del tren de pulsos rectangulares natural
pulso_rectangular_natural = 0.5*square(2*pi*frecuencia_muestreo_PAMn*tiempo, ciclo_trabajo_natural*100)+0.5;

%Aplicación de PAM natural sobre m(t) mediante multiplicación punto a punto
%entre los vectores m y pulso_rectangular_natural
PAM_natural = m.* pulso_rectangular_natural;

% 3) Parametros para la modulación PAM instantáneo (PAMi)
frecuencia_muestreo_PAMi = 5000;
periodo_muestreo_PAMi = 1/frecuencia_muestreo_PAMi;
ciclo_trabajo_instantaneo = 0.2;
tao_instantaneo = ciclo_trabajo_instantaneo/frecuencia_muestreo_PAMi;

%Creación del tren de pulsos rectangulares instantaneo
pulso_rectangular_instantaneo = 0.5*square(2*pi*frecuencia_muestreo_PAMi*tiempo, ciclo_trabajo_instantaneo*100)+0.5;

%Cada cuánto tiempo muestreamos la señal (en índices) (200us/10us = 20
%cada 20 muestras se toma el valor de m(t)
paso_muestras = round(periodo_muestreo_PAMi / periodo_muestreo_simulacion);

%Tomamos las muestras instantáneas de la señal m(t), estas son las que se
%mantienen a lo largo del ciclo de trabajo del pulso
muestras_instantaneas = m(1:paso_muestras:end);

%Crear el vector vacio (por ahora) para la señal PAM instantánea
PAM_instantaneo = zeros(size(m));

%Recorremos las muestras y las asignamos como pulsos rectangulares
for k = 1:length(muestras_instantaneas)
    % índice de inicio de cada pulso
    indice_inicio = (k-1)*paso_muestras + 1;
    % índice de fin (definido por el ancho del pulso tao)
    indice_fin = indice_inicio + round(tao_instantaneo/periodo_muestreo_simulacion) - 1;
    
    % aseguramos no pasarnos del tamaño de tiempo
    if indice_fin <= length(PAM_instantaneo)
        PAM_instantaneo(indice_inicio:indice_fin) = muestras_instantaneas(k);
    end
end

% 4) Gráfica comparativa

figure;
plot(tiempo*1e3, m, 'b', 'LineWidth', 1.2); hold on;
plot(tiempo*1e3, PAM_natural, 'r', 'LineWidth', 1);
plot(tiempo*1e3, PAM_instantaneo, 'g', 'LineWidth', 1);

grid on;
xlabel('Tiempo [ms]');
ylabel('Amplitud');
legend('Señal original m(t)', 'PAM natural', 'PAM instantáneo');
title('Comparación: PAM natural vs PAM instantáneo');

%% Actividad presencial

% 1) Realizar tranformada de fourier sobre las tres señales

M = fft(m); % tranformada de fourier
fs = 5000; % frecuencia de muestreo
f = (0:length(M)-1)*fs/length(M);


figure;
plot(f,abs(M))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('FFT señal original')

% Fourier PAM natural
M2 = fft(PAM_natural); % tranformada de fourier
f = (0:length(M2)-1)*fs/length(M2); 

figure;
plot(f,abs(M2))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('FFT PAM natural')

% Fourier PAM instantaneo
M3 = fft(PAM_instantaneo); % tranformada de fourier
f = (0:length(M3)-1)*fs/length(M3); 

figure;
plot(f,abs(M3))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('FFT PAM instantaneo')

%LINEA DE TESTEO%