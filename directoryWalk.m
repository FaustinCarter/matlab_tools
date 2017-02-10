function [dwOut]=directoryWalk(varargin)
%Directory Walk:
%By: Faustin Carter, 04/14/2014

%This function takes 0, 1, or 2 parameters. You can give them in any order.
%One parameter must be a directory path, and the other must be a cell
%array. Or you can specify just a path, or just a cell array.

%Directory walk recursively walks through the directory tree starting
%at the directory specified by currentDir. It returns a cell array of
%every filename it finds to dwOut. If you don't specify currentDir, it
%will ask you to choose one with the GUI. If you want, you can specify
%a starting cell array and it will append files to it, but you don't
%have to.


%%%%%%%%%%%%%%%%%% This block of code is just to parse inputs %%%%%%%%%%%%%

    %Check to make sure at least one, and no more than two inputs were specified
    narginchk(0,2);

    
    %This is the magic that sorts out the input parameters to make sure
    %they are the right type, and figures out which is which
    
    %Check to see how many input parameters are given
    switch nargin
        case 2 %if there are two...
            
            switch class(varargin{1}) %figure out what the first one is
                
                case 'cell'
                    outputList=varargin{1};
                    
                    if iscell(varargin{2}) %detecting stupidity...
                        error('Only one parameter may be a cell array');
                    end
                    
                case 'char'
                    currentDir=varargin{1};
                    
                    if ischar(varargin{2}) %detecting stupidity...
                        error('Only one parameter may be a directory path');
                    end
                
                otherwise
                    error('Parameters must be of type directory path and/or cell array');
            end
            
            switch class(varargin{2}) %figure out what the second one is
                
                case 'cell'
                    outputList=varargin{2};
                    
                case 'char'
                    currentDir=varargin{2};
                    
                otherwise
                    error('Parameters must be of type directory path and/or cell array');
            end
            
        case 1 %if there is one...
            
            switch class(varargin{1})
                
                case 'cell'
                    outputList=varargin{1};
                    currentDir=uigetdir();
                    
                case 'char'
                    currentDir=varargin{1};
                    outputList={};
                
                otherwise
                    error('Parameters must be of type directory and/or cell array');
            end
            
        case 0
            
            outputList={};
            currentDir=uigetdir();
            
    end
    
    %Check to make sure that any user-supplied path is actually to a
    %directory
    if ~isdir(currentDir)
        error('Must specify a valid directory path');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%% End of Input Parsing %%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% OK, this is where all the real stuff starts %%%%%%%%%%%%


    %Get the directory listing, and load it into a list called fileList
    fileList=dir(currentDir);

    %Loop through each one of those file names and do stuff
    for i=1:length(fileList)
        
        currentFile=fileList(i);

        switch currentFile.name
            case {'.','..'}
                %skip the . and .. directories

            otherwise

                if currentFile.isdir()
                    %Build a path to the first directory
                    workingDir=fullfile(currentDir, currentFile.name);

                    %Step further into the rabbit hole
                    outputList=directoryWalk(workingDir, outputList);
                else
                    %Your code goes here. Currently this just creates a
                    %list of every file found inside the nest of
                    %directories, but not the whole path.
                    
                    %If you wanted to get the whole path you could replace
                    %currentFile.name with:
                    %fullfile(currentDir, currentFile.name)
                    
                    %Or, you could do some intelligent file parsing and
                    %only grab names with .jpg extensions, etc....
                    outputList=[outputList currentFile.name];
                end

        end

    end
    
    %output the current list of stuff to the calling function
    dwOut=outputList;

end

