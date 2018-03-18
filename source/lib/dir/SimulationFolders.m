classdef SimulationFolders < handle
    % SIMULATIONFOLDERS Class to keep track of all output directories
    %   This class has one attribute for each source code or input
    %   directory. Every attribute can be reached by a static getter method.
    
    
    properties (SetAccess = private, GetAccess = public)
        simulations
        vegetation_stage
        vegetation_method
        vegetation_plant
        sim_name
        campaign
        campaign_date
        plot
        
        hr
        gnd
        veg
        sim_mode
        
        th0_deg
        afsa
        fscat
        geo
        position
        fzones
        distance
        incidence
        scattering
        observation
        
        pol
        config
        ant
        ant_lookup
        ant_real
        rot
        rot_lookup
        rot_real
        freq
        freqdiff
        freqdiff_b1
        freqdiff_b2
        freqdiff_b3
        freqdiff_b4
        freqdiff_P1
        freqdiff_P2
        freqdiff_P3
        freqdiff_P4
        out
        out_direct
        out_specular
        out_diffuse
        out_diffuse_b1
        out_diffuse_b2
        out_diffuse_b3
        out_diffuse_b4
        out_diffuse_P1
        out_diffuse_P2
        out_diffuse_P3
        out_diffuse_P4
        out_diffuse_NBRCS
        fig
        fig_direct
        fig_specular
        fig_diffuse
    end
    
    
    methods (Access = private)
        
        function obj = SimulationFolders
        end
        
    end
    
    
    methods (Static)
        function singleObj = getInstance
             persistent localObj
             
             if isempty(localObj) || ~isvalid(localObj)
                localObj = SimulationFolders;
             end
             
             singleObj = localObj;
        end
    end
        
    
    methods
        
        function initializeStaticDirs(obj)
            % Initialize static simulation directories

            obj.simulations = strcat( Directories.getInstance.main_dir, '\sims');
            
            obj.vegetation_method = strcat( obj.simulations, '\', SimParams.getInstance.vegetation_method );
            
            hr_folder = strcat( '\hr_', num2str(RecParams.getInstance.hr) );
            
            if strcmp( SimParams.getInstance.vegetation_method, Constants.veg_methods.HOMOGENOUS )
                
                obj.vegetation_plant = strcat( obj.vegetation_method, '\', SimParams.getInstance.vegetation_plant );
            
            elseif strcmp( SimParams.getInstance.vegetation_method, Constants.veg_methods.VIRTUAL )
                
                if SimParams.getInstance.vegetation_isRow
                    
                    obj.vegetation_plant = strcat( obj.vegetation_method, '-row', '\', SimParams.getInstance.vegetation_plant );
                
                else
                    
                    obj.vegetation_plant = strcat( obj.vegetation_method, '-rnd\', SimParams.getInstance.vegetation_plant );
                
                end
                
            end
            
            obj.vegetation_stage = strcat( obj.vegetation_plant, '\', VegParams.getInstance.vegetation_stage );
            
            obj.campaign = strcat( obj.vegetation_stage, '\', SimParams.getInstance.campaign );
            
            obj.campaign_date = strcat( obj.campaign, '-', SimParams.getInstance.campaign_date );
            
            obj.plot = strcat( obj.campaign_date, '-plot_', SimParams.getInstance.plot );
            
            obj.sim_name = strcat( obj.plot, '-', SimParams.getInstance.sim_name );
            
            
            %% Receiver Height
            obj.hr = strcat( obj.sim_name, hr_folder) ;  
           
            %% Ground
            obj.gnd = strcat(obj.hr, '\', 'GND') ;
            
            %% Vegetation
            obj.veg = strcat(obj.hr, '\', 'VEG') ;
            
            %% Simulation Mode
            if SimSettings.getInstance.sim_mode == Constants.sim_mode.CROSS
                
                obj.sim_mode = strcat( obj.hr, '\', ConstantNames.set_simMode_cross );
            
            elseif SimSettings.getInstance.sim_mode == Constants.sim_mode.TIME_SERIES
                
                obj.sim_mode = strcat( obj.hr, '\', ConstantNames.set_simMode_timeSeries );
                
            end
        end
        
        
        function initializeDynamicDirs(obj)
            % Initialize dynamically changing simulation directories
            
            %% Get Global Parameters
            th0_deg = SatParams.getInstance.th0_deg;
            PH0_deg = SatParams.getInstance.PH0_deg;
            
            %% Angle of incidence
            th0d_folder = strcat('th0d_', num2str( th0_deg( ParamsManager.index_Th ) ), ...
                                 '-ph0d_', num2str( PH0_deg( ParamsManager.index_Ph ) ) ) ;
            obj.th0_deg = strcat(obj.sim_mode, '\', th0d_folder) ;
            
            %% Average Forward Scattering Amplitude
            obj.afsa = strcat(obj.th0_deg, '\', 'AFSA') ;
            
            %% Bistatic Scattering Amplitudes
            obj.fscat = strcat(obj.th0_deg, '\', 'FSCAT') ;
            
            %% Geometry
            obj.geo = strcat(obj.th0_deg, '\', 'GEO') ;
            obj.position = strcat(obj.geo, '\', 'POSITION') ;                        
            obj.fzones = strcat(obj.geo, '\', 'FZONES') ;            
            obj.distance = strcat(obj.geo, '\', 'DISTANCE') ;            
            obj.incidence = strcat(obj.geo, '\', 'INCIDENCE') ;            
            obj.scattering = strcat(obj.geo, '\', 'SCATTERING') ;            
            obj.observation = strcat(obj.geo, '\', 'OBSERVATION') ;
            
            %% Polarization
            obj.pol = strcat(obj.th0_deg, '\', SatParams.getInstance.polT, RecParams.getInstance.polR) ;
            
            %Configuration
            obj.config = strcat(obj.th0_deg, '\', 'CONFIG') ;
            
            %% Antenna
            FolderNameAnt = strcat('thsd_', num2str(RecParams.getInstance.hpbw_deg),...
                '-SLL_', num2str(RecParams.getInstance.SLL_dB), '-XPL_', num2str(RecParams.getInstance.XPL_dB)) ;
            obj.ant = strcat(obj.th0_deg, '\', 'ANT\', FolderNameAnt) ;            
            obj.ant_lookup = strcat(obj.ant, '\', 'LOOK-UP') ;            
            obj.ant_real = strcat(obj.ant, '\', 'REALIZATION') ;
            
            %% Rotation
            obj.rot = strcat(obj.pol, '\', 'ROT') ;            
            obj.rot_lookup = strcat(obj.rot, '\', 'LOOK-UP') ;            
            obj.rot_real = strcat(obj.rot, '\', 'REALIZATION') ;
            
            %% Frequency Response
            obj.freq = strcat(obj.pol, '\FREQ\', FolderNameAnt) ;            
            obj.freqdiff = strcat(obj.freq, '\', 'DIFFUSE') ;            
            obj.freqdiff_b1 = strcat(obj.freqdiff, '\', 'b1') ;            
            obj.freqdiff_b2 = strcat(obj.freqdiff, '\', 'b2') ;            
            obj.freqdiff_b3 = strcat(obj.freqdiff, '\', 'b3') ;            
            obj.freqdiff_b4 = strcat(obj.freqdiff, '\', 'b4') ;            
            obj.freqdiff_P1 = strcat(obj.freqdiff, '\', 'P1') ;            
            obj.freqdiff_P2 = strcat(obj.freqdiff, '\', 'P2') ;            
            obj.freqdiff_P3 = strcat(obj.freqdiff, '\', 'P3') ;            
            obj.freqdiff_P4 = strcat(obj.freqdiff, '\', 'P4') ;
            
            %% Output
            obj.out = strcat(obj.pol, '\OUTPUT\', FolderNameAnt) ;
            obj.out_direct = strcat(obj.out, '\', 'DIRECT') ;
            obj.out_specular = strcat(obj.out, '\', 'SPECULAR') ;
            obj.out_diffuse = strcat(obj.out, '\', 'DIFFUSE') ;
            obj.out_diffuse_b1 = strcat(obj.out_diffuse, '\', 'b1') ;
            obj.out_diffuse_b2 = strcat(obj.out_diffuse, '\', 'b2') ;
            obj.out_diffuse_b3 = strcat(obj.out_diffuse, '\', 'b3') ;
            obj.out_diffuse_b4 = strcat(obj.out_diffuse, '\', 'b4') ;
            obj.out_diffuse_P1 = strcat(obj.out_diffuse, '\', 'P1') ;
            obj.out_diffuse_P2 = strcat(obj.out_diffuse, '\', 'P2') ;
            obj.out_diffuse_P3 = strcat(obj.out_diffuse, '\', 'P3') ;
            obj.out_diffuse_P4 = strcat(obj.out_diffuse, '\', 'P4') ;
            obj.out_diffuse_NBRCS = strcat(obj.out_diffuse, '\', 'NBRCS') ;
            
            %% Figure
            obj.fig = strcat(obj.hr, '\', 'FIGURE\', FolderNameAnt) ;
            obj.fig_direct = strcat(obj.fig, '\', 'DIRECT') ;
            obj.fig_specular = strcat(obj.fig, '\', 'SPECULAR') ;
            obj.fig_diffuse = strcat(obj.fig, '\', 'DIFFUSE') ;
            
            obj.makeDynamicDirs();
                        
        end
        
        
        function makeStaticDirs(obj)
        
            %% Receiver Height
            if ~exist(obj.hr, 'dir')
                mkdir(obj.hr);
            end

            %% Ground
            if ~exist(obj.gnd, 'dir')
                mkdir(obj.gnd)
            end
            
            %% Vegetation
            if ~exist(obj.veg, 'dir')
                mkdir(obj.veg)
            end   
            
            %% Simulation Mode
            if ~exist(obj.sim_mode, 'dir')
                mkdir(obj.sim_mode)
            end
            
            if strcmp( SimParams.getInstance.vegetation_method, Constants.veg_methods.HOMOGENOUS )
                VegParams.getInstance.write;
            end
        
        end
        
        
        function makeDynamicDirs(obj)
            
            %% Angle of incidence
            if ~exist(obj.th0_deg, 'dir')
                mkdir(obj.th0_deg)
            end

            %% Average Forward Scattering Amplitude
            if ~exist(obj.afsa, 'dir')
                mkdir(obj.afsa)
            end

            %% Bistatic Scattering Amplitudes
            if ~exist(obj.fscat, 'dir')
                mkdir(obj.fscat)
            end

            %% Geometry
            if ~exist(obj.geo, 'dir')
                mkdir(obj.geo)
            end

            if ~exist(obj.position, 'dir')
                mkdir(obj.position)
            end

            if ~exist(obj.fzones, 'dir')
                mkdir(obj.fzones)
            end

            if ~exist(obj.distance, 'dir')
                mkdir(obj.distance)
            end

            if ~exist(obj.incidence, 'dir')
                mkdir(obj.incidence)
            end

            if ~exist(obj.scattering, 'dir')
                mkdir(obj.scattering)
            end

            if ~exist(obj.observation, 'dir')
                mkdir(obj.observation)
            end
            
            %% Polarization
            if ~exist(obj.pol, 'dir')
                mkdir(obj.pol)
            end

            %% Configuration
            if ~exist(obj.config, 'dir')
                mkdir(obj.config)
            end

            %% Antenna
            if ~exist(obj.ant, 'dir')
                mkdir(obj.ant)
            end

            if ~exist(obj.ant_lookup, 'dir')
                mkdir(obj.ant_lookup)
            end

            if ~exist(obj.ant_real, 'dir')
                mkdir(obj.ant_real)
            end

            %% Rotation
            if ~exist(obj.rot, 'dir')
                mkdir(obj.rot)
            end

            if ~exist(obj.rot_lookup, 'dir')
                mkdir(obj.rot_lookup)
            end

            if ~exist(obj.rot_real, 'dir')
                mkdir(obj.rot_real)
            end

            %% Frequency Response
            if ~exist(obj.freq, 'dir')
                mkdir(obj.freq)
            end

            if ~exist(obj.freqdiff, 'dir')
                mkdir(obj.freqdiff)
            end

            if ~exist(obj.freqdiff_b1, 'dir')
                mkdir(obj.freqdiff_b1)
            end

            if ~exist(obj.freqdiff_b2, 'dir')
                mkdir(obj.freqdiff_b2)
            end

            if ~exist(obj.freqdiff_b3, 'dir')
                mkdir(obj.freqdiff_b3)
            end

            if ~exist(obj.freqdiff_b4, 'dir')
                mkdir(obj.freqdiff_b4)
            end

            if ~exist(obj.freqdiff_P1, 'dir')
                mkdir(obj.freqdiff_P1)
            end

            if ~exist(obj.freqdiff_P2, 'dir')
                mkdir(obj.freqdiff_P2)
            end

            if ~exist(obj.freqdiff_P3, 'dir')
                mkdir(obj.freqdiff_P3)
            end

            if ~exist(obj.freqdiff_P4, 'dir')
                mkdir(obj.freqdiff_P4)
            end

            %% Output
            if ~exist(obj.out, 'dir')
                mkdir(obj.out)
            end

            if ~exist(obj.out_direct, 'dir')
                mkdir(obj.out_direct)
            end

            if ~exist(obj.out_specular, 'dir')
                mkdir(obj.out_specular)
            end

            if ~exist(obj.out_diffuse, 'dir')
                mkdir(obj.out_diffuse)
            end

            if ~exist(obj.out_diffuse_b1, 'dir')
                mkdir(obj.out_diffuse_b1)
            end

            if ~exist(obj.out_diffuse_b2, 'dir')
                mkdir(obj.out_diffuse_b2)
            end

            if ~exist(obj.out_diffuse_b3, 'dir')
                mkdir(obj.out_diffuse_b3)
            end

            if ~exist(obj.out_diffuse_b4, 'dir')
                mkdir(obj.out_diffuse_b4)
            end

            if ~exist(obj.out_diffuse_P1, 'dir')
                mkdir(obj.out_diffuse_P1)
            end

            if ~exist(obj.out_diffuse_P2, 'dir')
                mkdir(obj.out_diffuse_P2)
            end
            if ~exist(obj.out_diffuse_P3, 'dir')
                mkdir(obj.out_diffuse_P3)
            end

            if ~exist(obj.out_diffuse_P4, 'dir')
                mkdir(obj.out_diffuse_P4)
            end

            if ~exist(obj.out_diffuse_NBRCS, 'dir')
                mkdir(obj.out_diffuse_NBRCS)
            end

            % Figure
            if ~exist(obj.fig, 'dir')
                mkdir(obj.fig)
            end

            if ~exist(obj.fig_direct, 'dir')
                mkdir(obj.fig_direct)
            end

            if ~exist(obj.fig_specular, 'dir')
                mkdir(obj.fig_specular)
            end

            if ~exist(obj.fig_diffuse, 'dir')
                mkdir(obj.fig_diffuse)
            end
        
        end
        
        function out = get.simulations(obj)
            out = obj.simulations;        
        end
        
        function out = get.vegetation_stage(obj)
            out = obj.vegetation_stage;
        end
        
        function out = get.vegetation_method(obj)
            out = obj.vegetation_method;
        end
        
        function out = get.campaign(obj)
            out = obj.campaign;
        end
        
        function out = get.campaign_date(obj)
            out = obj.campaign_date;
        end
        
        function out = get.plot(obj)
            out = obj.plot;
        end
        
        function out = get.sim_name(obj)
            out = obj.sim_name;
        end
        
        function out = get.vegetation_plant(obj)
            out = obj.vegetation_plant;
        end  
        
        function out = get.hr(obj)
            out = obj.hr;
        end 
        
        function out = get.veg(obj)
            out = obj.veg;
        end 
        
        function out = get.th0_deg(obj)
            out = obj.th0_deg;
        end 
        
        function out = get.afsa(obj)
            out = obj.afsa;
        end 
        
        function out = get.fscat(obj)
            out = obj.fscat;
        end 
        
        function out = get.position(obj)
            out = obj.position;
        end 
        
        function out = get.fzones(obj)
            out = obj.fzones;
        end 
        
        function out = get.distance(obj)
            out = obj.distance;
        end 
        
        function out = get.incidence(obj)
            out = obj.incidence;
        end 
        
        function out = get.scattering(obj)
            out = obj.scattering;
        end 
        
        function out = get.observation(obj)
            out = obj.observation;
        end 
        
        function out = get.gnd(obj)
            out = obj.gnd;
        end 
        
        function out = get.pol(obj)
            out = obj.pol;
        end 
        
        function out = get.config(obj)
            out = obj.config;
        end 
        
        function out = get.ant(obj)
            out = obj.ant;
        end 
        
        function out = get.ant_lookup(obj)
            out = obj.ant_lookup;
        end 
        
        function out = get.ant_real(obj)
            out = obj.ant_real;
        end
        
        function out = get.rot(obj)
            out = obj.rot;
        end
        
        function out = get.rot_lookup(obj)
            out = obj.rot_lookup;
        end
        
        function out = get.rot_real(obj)
            out = obj.rot_real;
        end
        
        function out = get.freq(obj)
            out = obj.freq;
        end
        
        function out = get.freqdiff(obj)
            out = obj.freqdiff;
        end
        
        function out = get.freqdiff_b1(obj)
            out = obj.freqdiff_b1;
        end
        
        function out = get.freqdiff_b2(obj)
            out = obj.freqdiff_b2;
        end
        
        function out = get.freqdiff_b3(obj)
            out = obj.freqdiff_b3;
        end
        
        function out = get.freqdiff_b4(obj)
            out = obj.freqdiff_b4;
        end
        
        function out = get.freqdiff_P1(obj)
            out = obj.freqdiff_P1;
        end
        
        function out = get.freqdiff_P2(obj)
            out = obj.freqdiff_P2;
        end
        
        function out = get.freqdiff_P3(obj)
            out = obj.freqdiff_P3;
        end
        
        function out = get.freqdiff_P4(obj)
            out = obj.freqdiff_P4;
        end
        
        function out = get.out(obj)
            out = obj.out;
        end
        
        function out = get.out_direct(obj)
            out = obj.out_direct;
        end
        
        function out = get.out_specular(obj)
            out = obj.out_specular;
        end
        
        function out = get.out_diffuse(obj)
            out = obj.out_diffuse;
        end
        
        function out = get.out_diffuse_b1(obj)
            out = obj.out_diffuse_b1;
        end
        
        function out = get.out_diffuse_b2(obj)
            out = obj.out_diffuse_b2;
        end
        
        function out = get.out_diffuse_b3(obj)
            out = obj.out_diffuse_b3;
        end
        
        function out = get.out_diffuse_b4(obj)
            out = obj.out_diffuse_b4;
        end
        
        function out = get.out_diffuse_P1(obj)
            out = obj.out_diffuse_P1;
        end
        
        function out = get.out_diffuse_P2(obj)
            out = obj.out_diffuse_P2;
        end
        
        function out = get.out_diffuse_P3(obj)
            out = obj.out_diffuse_P3;
        end
        
        function out = get.out_diffuse_P4(obj)
            out = obj.out_diffuse_P4;
        end
        
        function out = get.out_diffuse_NBRCS(obj)
            out = obj.out_diffuse_NBRCS;
        end
        
        function out = get.fig(obj)
            out = obj.fig;
        end
        
        function out = get.fig_direct(obj)
            out = obj.fig_direct;
        end
        
        function out = get.fig_specular(obj)
            out = obj.fig_specular;
        end
        
        function out = get.fig_diffuse(obj)
            out = obj.fig_diffuse;
        end
        
    end
    
end
