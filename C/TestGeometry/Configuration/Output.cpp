// Copyright (C) 2014 Vicini Fabio
//
// This file is part of the dissertation of the author.
//
// This is a free program: you can redistribute it and/or modify
// it under the terms of the author.
//
// This program is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE.
//
// Modified by Vicini Fabio 2014
//
// First added:  2014-10-05

#include "Output.hpp"
#include "MacroDefinitions.hpp"

#include <sys/stat.h>
#include <sys/types.h>
#include <cstdlib>
#include <cstring>
#include <string>
#include <iostream>
#include <sstream>
#include <unistd.h>
#include <limits>

#ifdef _WIN32
#include <unistd.h>
#include <ctime>
#elif __linux__
#include <sys/sysinfo.h>
#endif // _WIN32

#include <iomanip>

using namespace Configuration;

namespace MainApplication
{
	// ***************************************************************************
	#ifdef _WIN32
	string Output::BlueColor = "";
	string Output::RedColor = "";
	string Output::GreenColor = "";
	string Output::YellowColor = "";
	string Output::EndColor = "";
	#elif __linux__
	string Output::BlueColor = "\033[1;34m";
	string Output::RedColor = "\033[1;31m";
	string Output::GreenColor = "\033[1;32m";
	string Output::YellowColor = "\033[1;33m";
	string Output::EndColor = "\033[0m";
	#endif // _WIN32
	unsigned int Output::Rank = 0;
	unsigned int Output::NumberProcesses = 1;
	// ***************************************************************************
	void Output::Initialize(const unsigned int& rank, const unsigned int& numProcesses)
	{
		Rank = rank;
		NumberProcesses = numProcesses;

		LogFile::Initialize(rank, numProcesses);
		Profiler::Initialize(rank, numProcesses);
	}
	// ***************************************************************************
	void Output::CreateFolder(const string& nameFolder)
	{
		vector<string> folders = ConfigFile::StringSplit(nameFolder, '/');
		ostringstream nameFolderPath;

		for(unsigned int i = 0; i < folders.size(); i++)
		{
			nameFolderPath<< folders[i]<< "/";

			if(folders[i] == ".")
				continue;

			#ifdef _WIN32
			mkdir(nameFolderPath.str().c_str());
			#elif __linux__
			mkdir(nameFolderPath.str().c_str(), 0777);
			#endif
		}
	}
	// ***************************************************************************
	bool Output::FileExists(const string& nameFile)
	{
		bool fileExists = false;

		#ifdef _WIN32
		fileExists = (_access(nameFile.c_str(), 0) != -1);
		#elif __linux__
		fileExists = (access(nameFile.c_str(), F_OK) != -1);
		#endif // _WIN32

		return fileExists;
	}
	// ***************************************************************************
	void Output::GetFilePath(const string& nameFilePath, string& filePath, string& fileName, string& fileExtension)
	{
		size_t foundPath = nameFilePath.find_last_of("/\\");
		size_t foundExtension = nameFilePath.find_last_of(".");

		if (foundPath != string::npos)
			filePath = nameFilePath.substr(0, foundPath + 1);

		if (foundPath != string::npos && foundExtension != string::npos)
			fileName = nameFilePath.substr(foundPath + 1, foundExtension - foundPath - 1);
		else if (foundPath != string::npos)
			fileName = nameFilePath.substr(foundPath + 1);
		else if (foundExtension != string::npos)
			fileName = nameFilePath.substr(0, foundExtension);
		else
			fileName = nameFilePath;

		if (foundExtension != string::npos && ((foundPath != string::npos && foundPath < foundExtension) || foundPath == string::npos) )
			fileExtension = nameFilePath.substr(foundExtension + 1);
	}
	// ***************************************************************************
	const bool Output::ReadBinaryFile(const string& nameFile, vector<double>& dataToRead, const unsigned int& dataSizeToRead, const unsigned int& startingPosition)
	{
		/// <ul>

		/// <li> Open file
		ifstream file;
		file.open(nameFile.c_str(), ios::binary | ios::ate);
		if (file.fail())
		{
      Output::PrintErrorMessage("File '%s' cannot be opened", false, nameFile.c_str());
			return false;
		}

		/// <li> Get file size
		streamsize fileSize = file.tellg();

		if (fileSize < (int) (startingPosition * sizeof(double)))
		{
			Output::PrintErrorMessage("Error in file '%s': uncorrect starting position. Expected %d, obtained %d", false, nameFile.c_str(), startingPosition, fileSize / sizeof(double));
			return false;
		}

		fileSize -= startingPosition * sizeof(double);
		file.seekg(startingPosition * sizeof(double));

		if (fileSize < (int) (dataSizeToRead * sizeof(double)))
		{
			Output::PrintErrorMessage("Error in file '%s': uncorrect size. Expected %d, obtained %d", false, nameFile.c_str(), dataSizeToRead, fileSize / sizeof(double));
			return false;
		}

		if (fileSize == 0)
			return true;

		/// <li> Read from file
		unsigned int fileSizeToRead = dataSizeToRead == 0 ? fileSize : dataSizeToRead * sizeof(double);
		int fileContentSize = dataSizeToRead == 0 ? fileSize / sizeof(double) : dataSizeToRead;

		if (fileContentSize == 0)
		{
			Output::PrintErrorMessage("Error in file '%s': uncorrect content size. Obtained %d", false, nameFile.c_str(), fileContentSize);
			return false;
		}

		dataToRead.resize(fileContentSize, 0.0);
		file.read((char*)dataToRead.data(), fileSizeToRead);

		file.close();

		/// </ul>

		return true;
	}
	// ***************************************************************************
	const bool Output::WriteBinaryFile(const string& nameFile, const vector<double>& dataToWrite, const unsigned int& dataSizeToWrite, const unsigned int& dataStartingPositionToWrite, const bool& append)
	{
		/// <ul>

		if (dataSizeToWrite > dataToWrite.size())
		{
			Output::PrintErrorMessage("Error in write file '%s': uncorrect size. Required %d, given %d", false, nameFile.c_str(), dataSizeToWrite, dataToWrite.size());
			return false;
		}

		if (dataStartingPositionToWrite > dataToWrite.size())
		{
			Output::PrintErrorMessage("Error in write file '%s': uncorrect starting position. Required %d, given %d", false, nameFile.c_str(), dataStartingPositionToWrite, dataToWrite.size());
			return false;
		}

		unsigned int fileDataSize = (dataSizeToWrite == 0) ? dataToWrite.size() : dataSizeToWrite;

		if (fileDataSize == 0)
			return true;

		/// <li> Exporting file
		ofstream file;

		if (append)
			file.open(nameFile.c_str(), ios::binary | ofstream::app);
		else
			file.open(nameFile.c_str(), ios::binary);

		if(file.fail())
		{
      Output::PrintErrorMessage("File '%s' cannot be opened", false, nameFile.c_str());
			return false;
		}

		file.write((char *)(dataToWrite.data() + dataStartingPositionToWrite), fileDataSize * sizeof(double));
		file.close();

		/// </ul>

		return true;
	}
	// ***************************************************************************
	void Output::PrintLine(char symbol, bool onlyMaster)
	{
		#if VERBOSE > 0

		if (onlyMaster && Rank != 0)
			return;

		#if VERBOSE==1 || VERBOSE==3
		cout << " >> ";
		for (int i = 1; i < 72; i++)
			cout<< symbol;
		cout<< endl;
		#endif

		#if VERBOSE==2 || VERBOSE==3
		LogFile::PrintLine(symbol);
		#endif

		#endif // VERBOSE
	}
	// ***************************************************************************
	ostream& Output::PrintStars(ostream& out)
	{
		for (int i = 1; i < 76; i++)
			out<< '*';
		out<< endl;

		return out;
	}
	// **********************************
	ostream& Output::PrintLines(ostream& out)
	{
		for (int i = 1; i < 76; i++)
			out<< '-';
		out<< endl;

		return out;
	}
	// ***************************************************************************
	void Output::PrintStatusProgram(const string& message, ...)
	{
		#if VERBOSE > 0

		if (Rank != 0)
			return;

		va_list args, dupArgs;
		va_start(args, message);
		va_copy(dupArgs, args);

		// Printing
		ostringstream newMessage;
		#if VERBOSE==1 || VERBOSE==3
		newMessage<< " >> "<< message<< " "<< Output::GreenColor<< "SUCCESS"<< Output::EndColor;
		newMessage<< endl;

		vprintf(newMessage.str().c_str(), args);
		#endif

		#if VERBOSE==2 || VERBOSE==3
		newMessage.str("");
		newMessage.clear();
		newMessage<< message<< " "<< "SUCCESS";
		LogFile::PrintInfoMessage(newMessage.str(), dupArgs);
		#endif

		va_end(args);

		#endif // VERBOSE
	}
	// ***************************************************************************
	void Output::PrintGenericMessageOnLine(const string& message, ...)
	{
		#if VERBOSE > 0

		if (Rank != 0)
			return;

		va_list args;
		va_start(args, message);

		// Printing
		#if VERBOSE==1 || VERBOSE==3
		ostringstream newMessage;
		newMessage<< "\r"<< message;
		newMessage<< flush;

		vprintf(newMessage.str().c_str(), args);
    cout<< flush;
		#endif

		va_end(args);

		#endif // VERBOSE
	}
	// ***************************************************************************
	void Output::PrintGenericMessage(const string& message, const bool& onlyMaster, ...)
	{
		#if VERBOSE > 0

		if (onlyMaster && Rank != 0)
			return;

		va_list args, dupArgs;
		va_start(args, onlyMaster);
		va_copy(dupArgs, args);

		// Printing
		#if VERBOSE==1 || VERBOSE==3
		ostringstream newMessage;
		newMessage<< " >> "<< message;
		if(!onlyMaster)
			newMessage<< " on process "<< Rank;
		newMessage<< endl;

		vprintf(newMessage.str().c_str(), args);
		#endif

		#if VERBOSE==2 || VERBOSE==3
		LogFile::PrintInfoMessage(message, dupArgs);
		#endif

		va_end(args);

		#endif // VERBOSE
	}
	// ***************************************************************************
	void Output::PrintErrorMessage(const string& message, const bool& onlyMaster, ...)
	{
		#if VERBOSE > 0

		if (onlyMaster && Rank != 0)
			return;

		va_list args, dupArgs;
		va_start(args, onlyMaster);
		va_copy(dupArgs, args);

		ostringstream newMessage;
		newMessage<< Output::RedColor<< " >> "<< message<< Output::EndColor;
		if(!onlyMaster)
			newMessage<< " on process "<< Rank;
		newMessage<< endl;

		vprintf(newMessage.str().c_str(), args);

		#if VERBOSE==2 || VERBOSE==3
		LogFile::PrintErrorMessage(message, dupArgs);
		#endif

		va_end(args);

		#endif // VERBOSE
	}
	// ***************************************************************************
	void Output::PrintWarningMessage(const string& message, const bool& onlyMaster, ...)
	{
		#if VERBOSE > 0

		if (onlyMaster && Rank != 0)
			return;

		va_list args, dupArgs;
		va_start(args, onlyMaster);
		va_copy(dupArgs, args);

		ostringstream newMessage;
		newMessage<< Output::YellowColor<< " >> "<< message<< Output::EndColor;
		if(!onlyMaster)
			newMessage<< " on process "<< Rank;
		newMessage<< endl;

		vprintf(newMessage.str().c_str(), args);

		#if VERBOSE==2 || VERBOSE==3
		LogFile::PrintWarningMessage(message, dupArgs);
		#endif

		va_end(args);

		#endif // VERBOSE
	}
	// ***************************************************************************
	void Output::PrintSuccessMessage(const string& message, const bool& onlyMaster, ...)
	{
		#if VERBOSE > 0

		if (onlyMaster && Rank != 0)
			return;

		va_list args, dupArgs;
		va_start(args, onlyMaster);
		va_copy(dupArgs, args);

		#if VERBOSE==1 || VERBOSE==3
		ostringstream newMessage;
		newMessage<< Output::GreenColor<< " >> "<< message<< Output::EndColor;
		if(!onlyMaster)
			newMessage<< " on process "<< Rank;
		newMessage<< endl;

		vprintf(newMessage.str().c_str(), args);
		#endif

		#if VERBOSE==2 || VERBOSE==3
		LogFile::PrintInfoMessage(message, dupArgs);
		#endif

		va_end(args);

		#endif // VERBOSE
	}
	// ***************************************************************************
	void Output::Assert(const bool& logicResult, const string& message, ...)
	{
		#if VERBOSE > 0

		if (Rank != 0)
			return;

		va_list args, dupArgs;
		va_start(args, message);
		va_copy(dupArgs, args);

		// Printing
		ostringstream newMessage;
		#if VERBOSE==1 || VERBOSE==3
		newMessage<< " >> "<< message<< " ";
		if (logicResult)
			newMessage<< Output::GreenColor<< "SUCCESS"<< Output::EndColor;
		else
			newMessage<< Output::RedColor<< "FAILED"<< Output::EndColor;

		newMessage<< endl;

		vprintf(newMessage.str().c_str(), args);
		#endif

		#if VERBOSE==2 || VERBOSE==3
		newMessage.str("");
		newMessage.clear();
		newMessage<< message<< " ";
		if (logicResult)
			newMessage<< "SUCCESS";
		else
			newMessage<< "FAILED";

		LogFile::PrintInfoMessage(newMessage.str(), dupArgs);
		#endif

		va_end(args);

		#endif // VERBOSE
	}
	// ***************************************************************************
	void Output::Assert(const ExitCodes& logicResult, const string& message, ...)
	{
		#if VERBOSE > 0

		if (Rank != 0)
			return;

		va_list args, dupArgs;
		va_start(args, message);
		va_copy(dupArgs, args);

		// Printing
		ostringstream newMessage;
		#if VERBOSE==1 || VERBOSE==3
		newMessage<< " >> "<< message<< " ";
		switch (logicResult)
		{
			case Output::Success:
				newMessage<< Output::GreenColor<< "SUCCESS"<< Output::EndColor;
				break;
			case Output::MpiError:
				newMessage<< Output::RedColor<< "FAILED (MpiError)"<< Output::EndColor;
				break;
			case Output::GenericError:
				newMessage<< Output::RedColor<< "FAILED (GenericError)"<< Output::EndColor;
				break;
			case Output::PartitionError:
				newMessage<< Output::RedColor<< "FAILED (PartitionError)"<< Output::EndColor;
				break;
			case Output::Abort:
				newMessage<< Output::RedColor<< "FAILED (Abort)"<< Output::EndColor;
				break;
			case Output::FileError:
				newMessage<< Output::RedColor<< "FAILED (FileError)"<< Output::EndColor;
				break;
			case Output::UnimplementedMethod:
				newMessage<< Output::RedColor<< "FAILED (UnimplementedMethod)"<< Output::EndColor;
				break;
			default:
				newMessage<< Output::RedColor<< "FAILED (Unknown)"<< Output::EndColor;
				break;
		}

		newMessage<< endl;

		vprintf(newMessage.str().c_str(), args);
		#endif

		#if VERBOSE==2 || VERBOSE==3
		newMessage.str("");
		newMessage.clear();
		newMessage<< message<< " ";

		switch (logicResult)
		{
			case Output::Success:
				newMessage<< "SUCCESS";
				break;
			case Output::MpiError:
				newMessage<< "FAILED (MpiError)";
				break;
			case Output::GenericError:
				newMessage<< "FAILED (GenericError)";
				break;
			case Output::PartitionError:
				newMessage<< "FAILED (PartitionError)";
				break;
			case Output::Abort:
				newMessage<< "FAILED (Abort)";
				break;
			case Output::FileError:
				newMessage<< "FAILED (FileError)";
				break;
			case Output::UnimplementedMethod:
				newMessage<< "FAILED (UnimplementedMethod)";
				break;
			default:
				newMessage<< "FAILED (Unknown)";
				break;
		}

		LogFile::PrintInfoMessage(newMessage.str(), dupArgs);
		#endif

		va_end(args);

		#endif // VERBOSE
	}
	// ***************************************************************************
	unsigned int LogFile::Rank = 0;
	unsigned int LogFile::NumberProcesses = 1;
	// ***************************************************************************
	string LogFile::GetDateTime()
	{
		ostringstream timeBuilder;

		time_t now = time(0);   // get time now
		tm* ltm = localtime(&now);

		// print various components of tm structure.
		timeBuilder<< setfill('0') << setw(4)<< 1900 + ltm->tm_year<< "/";
		timeBuilder<< setfill('0') << setw(2)<< (1 + ltm->tm_mon)<< "/";
		timeBuilder<< setfill('0') << setw(2)<< ltm->tm_mday<< " ";
		timeBuilder<< setfill('0') << setw(2)<< ltm->tm_hour<< ":";
		timeBuilder<< setfill('0') << setw(2)<< ltm->tm_min<< ":";
		timeBuilder<< setfill('0') << setw(2)<< ltm->tm_sec;

    return timeBuilder.str();
	}
	// ***************************************************************************
	double LogFile::GetFileSize(const string& nameFile)
	{
		streampos begin,end;
		ifstream file(nameFile.c_str());
		begin = file.tellg();
		file.seekg (0, ios::end);
		end = file.tellg();
		file.close();
		double fileSize = (end - begin) / 100000.0; // MegaBytes

		return fileSize;
	}
	// ***************************************************************************
	void LogFile::CheckFileSize(const string& nameFile)
	{
		if(!Output::FileExists(nameFile))
			return;

		// Check file dimension
		double actualFileSize = GetFileSize(nameFile);
		if(actualFileSize > ConfigFile::Log().LogMaxFileSize())
		{
			// Create new log file
			ostringstream newNameFile, oldNameFile;
			int maxFiles = ConfigFile::Log().LogMaxNumFiles(), numFiles = maxFiles;

			newNameFile<< nameFile<< "_"<< numFiles;
			if(Output::FileExists(newNameFile.str()))
				remove(newNameFile.str().c_str());

			do
			{
				if(numFiles > 1)
					oldNameFile<< nameFile<< "_"<< (numFiles - 1);
				else
					oldNameFile<< nameFile;

				if(Output::FileExists(oldNameFile.str()))
					rename(oldNameFile.str().c_str(), newNameFile.str().c_str());

				newNameFile.str("");
				newNameFile.clear();
				oldNameFile.str("");
				oldNameFile.clear();

				numFiles--;
				newNameFile<< nameFile<< "_"<< numFiles;
			}
			while(numFiles > 0);
		}
	}
	// ***************************************************************************
	void LogFile::PrintMessage(const string& type, const string& message, va_list args)
	{
		#if USE_MPI == 1
		int rank = MPI::COMM_WORLD.Get_rank();
		#elif USE_MPI == 0
		int rank = 0;
		#endif // USE_MPI

		if(rank != 0)
			return;

		ostringstream nameFolder, nameFile;

		string outputData = "";
		if (ConfigFile::IsPropertyDefault(ConfigFile::FilesParam().OutputData()))
			outputData = ConfigFile::InParam().InputData();
		else
			outputData = ConfigFile::FilesParam().OutputData();

		nameFolder<< ConfigFile::FilesParam().OutputFolder();
		nameFolder<< outputData<< "/";
		nameFolder<< ConfigFile::InParam().RunId()<< "/";
		nameFolder<< ConfigFile::Log().LogFolder();
		Output::CreateFolder(nameFolder.str());

		nameFile<< nameFolder.str()<< ConfigFile::Log().LogFile();
		CheckFileSize(nameFile.str());

		if(args != NULL)
		{
			FILE * pFile = fopen(nameFile.str().c_str(),"a");

			ostringstream logMessage;
			logMessage<< GetDateTime()<< " ";
			if(!type.empty())
				logMessage<< type<< ": ";
			logMessage<< message<< endl;

			vfprintf(pFile, logMessage.str().c_str(), args);
			va_end(args);

			fclose(pFile);
		}
		else
		{
			ofstream outFile(nameFile.str().c_str(), std::ios_base::app);

			outFile<< GetDateTime()<< " ";
			if(!type.empty())
				outFile<< type<< ": ";
			outFile<< message<< endl;

			outFile.close();
		}
	}
	// ***************************************************************************
	void LogFile::PrintLine(const char& symbol)
	{
		ostringstream separatorBuilder;

		for (int i = 1; i < 61; i++)
			separatorBuilder<< symbol;

		LogFile::PrintMessage("", separatorBuilder.str(), NULL);
	}
	// ***************************************************************************
	void LogFile::PrintWarningMessage(const string& message, va_list args)
	{
		LogFile::PrintMessage("WARN", message, args);
	}
	// ***************************************************************************
	void LogFile::PrintErrorMessage(const string& message, va_list args)
	{
		LogFile::PrintMessage("ERR ", message, args);
	}
	// ***************************************************************************
	void LogFile::PrintInfoMessage(const string& message, va_list args)
	{
		LogFile::PrintMessage("INFO", message, args);
	}
	// ***************************************************************************
	void LogFile::PrintDebugMessage(const string& message, va_list args)
	{
		LogFile::PrintMessage("DBG ", message, args);
	}
	// ***************************************************************************
	unsigned int Profiler::Rank = 0;
	unsigned int Profiler::NumberProcesses = 1;
	map<string, double> Profiler::times;
	map<string, double> Profiler::localTimes;
	unsigned long Profiler::totalAvailStartingMemory = 0;
	// ***************************************************************************
	double Profiler::GetTime(const string& nameTime, const bool& localTime)
	{
		if(!ConfigFile::InParam().ActivateProfiler())
			return 0.0;

		double time = 0.0;

		if(localTime)
		{
			map<string, double>::iterator timeFound = localTimes.find(nameTime);
			if(timeFound != localTimes.end())
				time = timeFound->second;
		}
		else
		{
			map<string, double>::iterator timeFound = times.find(nameTime);
			if(timeFound != times.end())
				time = timeFound->second;
		}

		return time;
	}
	// ***************************************************************************
	void Profiler::StartTime(const string& nameTime)
	{
		if (!ConfigFile::InParam().ActivateProfiler())
			return;

		double time = 0.0;

		map<string, double>::iterator timeFound = times.find(nameTime);
		map<string, double>::iterator localTimeFound = localTimes.find(nameTime);

		if(timeFound != times.end())
      Output::PrintWarningMessage(" -- Profiling: Time '" + nameTime + "' restarted --", true);

		if(localTimeFound != localTimes.end())
      Output::PrintWarningMessage(" -- Profiling: Local Time '" + nameTime + "' restarted --", true);

		#if USE_MPI == 1
		MPI::COMM_WORLD.Barrier();
		time = MPI::Wtime();
		MPI::COMM_WORLD.Bcast(&time, 1, MPI::DOUBLE, 0);
		#elif USE_MPI == 0
		time = clock();
		#endif // USE_MPI

		if(timeFound != times.end())
      timeFound->second = time;
		else
			times.insert(pair<string, double>(nameTime, time));

		if(localTimeFound != localTimes.end())
      localTimeFound->second = time;
		else
			localTimes.insert(pair<string, double>(nameTime, time));
	}
	// *************************************************************************
	void Profiler::StopTime(const string& nameTime)
	{
		if (!ConfigFile::InParam().ActivateProfiler())
			return;

		double endTime = 0.0, localEndTime = 0.0;

		#if USE_MPI == 1
		localEndTime = MPI::Wtime();
		MPI::COMM_WORLD.Allreduce(&localEndTime, &endTime, 1, MPI::DOUBLE, MPI::MAX);
		#elif USE_MPI == 0
		localEndTime = clock();
		endTime = localEndTime;
		#endif // USE_MPI

		map<string, double>::iterator timeFound = times.find(nameTime);
		map<string, double>::iterator localTimeFound = localTimes.find(nameTime);
		if(timeFound == times.end())
		{
      Output::PrintErrorMessage(" -- Profiling: No time '" + nameTime + "' exists --", true);
      return;
		}
		if(localTimeFound == localTimes.end())
		{
      Output::PrintErrorMessage(" -- Profiling: No local time '" + nameTime + "' exists --", true);
      return;
		}

		double startTime = timeFound->second;
		double localStartTime = localTimeFound->second;
		#if USE_MPI == 1
		double timeDifference = endTime - startTime;
		double localTimeDifference = localEndTime - localStartTime;
		#elif USE_MPI == 0
		double timeDifference = (endTime - startTime) / (double)CLOCKS_PER_SEC;
		double localTimeDifference = (localEndTime - localStartTime) / (double)CLOCKS_PER_SEC;
		#endif // USE_MPI

		ostringstream nameFolder;

		string outputData = "";
		if (ConfigFile::IsPropertyDefault(ConfigFile::FilesParam().OutputData()))
			outputData = ConfigFile::InParam().InputData();
		else
			outputData = ConfigFile::FilesParam().OutputData();

		nameFolder<< ConfigFile::FilesParam().OutputFolder();
		nameFolder<< outputData<< "/";
		nameFolder<< ConfigFile::InParam().RunId()<< "/";
		nameFolder<< ConfigFile::Log().LogFolder();
		Output::CreateFolder(nameFolder.str());

		// Print global time file
		if(Rank == 0)
		{
			#if VERBOSE==1 || VERBOSE==3
			int hours = timeDifference / 3600;
			int minutes = (timeDifference - hours * 3600) / 60;
			int seconds = (timeDifference - hours * 3600 - minutes * 60);
			double milliseconds = (timeDifference - hours * 3600 - minutes * 60 - seconds) * 1000;
			cout<< " -- "<< Output::BlueColor<< "Profiling"<< Output::EndColor<< ": Time '"<< nameTime<< "': "<< hours<< " h "<< minutes<< " m "<< seconds<< " s "<< milliseconds<< " ms --"<< endl;
			#endif

			ostringstream nameFile;

			nameFile<< nameFolder.str()<< ConfigFile::Log().TimeFile();
			bool fileExists = Output::FileExists(nameFile.str());

			LogFile::CheckFileSize(nameFile.str());

			ofstream outFile(nameFile.str().c_str(), ios_base::app);
			outFile.precision(8);

			if(!fileExists)
			{
				outFile<< "TotProc"<< " ";
				outFile<< "Type"<< " ";
				outFile<< "Time"<< endl;
			}

			outFile<< scientific<< NumberProcesses<< " "<< nameTime<< " "<< timeDifference<< endl;
		}

		// Print local time files
		ostringstream nameFile;

		nameFolder<< "Processes/";
		Output::CreateFolder(nameFolder.str());

		nameFile<< nameFolder.str()<< ConfigFile::Log().TimeFile()<< Rank;
		bool fileExists = Output::FileExists(nameFile.str());

		LogFile::CheckFileSize(nameFile.str());

		ofstream outFile(nameFile.str().c_str(), ios_base::app);
		outFile.precision(8);

		if(!fileExists)
		{
			outFile<< "TotProc"<< " ";
			outFile<< "Type"<< " ";
			outFile<< "Time"<< endl;
		}

		outFile<< scientific<< NumberProcesses<< " "<< nameTime<< " "<< localTimeDifference<< endl;

		times[nameTime] = timeDifference;
		localTimes[nameTime] = localTimeDifference;
	}
	// *************************************************************************
	int Profiler::ParseLine(char* line)
	{
		int i = strlen(line);
		while (*line < '0' || *line > '9') line++;
		line[i-3] = '\0';
		i = atoi(line);

		return i;
	}
	// *************************************************************************
	void Profiler::GetProcessMemory(vector<unsigned long>& memoryUsed)
	{
		memoryUsed.resize(2, 0);

		// Get Virtual Memory
		string token;
    ifstream file("/proc/self/status");
		while(file >> token)
		{
			if(token == "VmSize:")
				file >> memoryUsed[0];
			if(token == "VmRSS:")
				file >> memoryUsed[1];

			file.ignore(numeric_limits<streamsize>::max(), '\n');
		}
		file.close();
	}
	// *************************************************************************
	void Profiler::GetTotalMemory(vector<unsigned long>& totalMemory)
	{
		// NOTE: It is possible also to get Virtual memory from the file using the SwapTotal and SwapFree
		totalMemory.resize(3, 0);

		string token;
    ifstream file("/proc/meminfo");
		while(file >> token)
		{
			if(token == "MemTotal:")
				file >> totalMemory[0];
			if(token == "MemAvailable:")
				file >> totalMemory[2];

			file.ignore(numeric_limits<streamsize>::max(), '\n');
		}
		file.close();

		// Get Used Physical Memory
		totalMemory[1] = totalMemory[0] - totalMemory[2];
	}
	// *************************************************************************
	void Profiler::CheckMemory(const string& nameMemory, const bool& checkProcessesMemory)
	{
		if(!ConfigFile::InParam().ActivateProfiler())
			return;

		#if USE_MPI == 1
		MPI::COMM_WORLD.Barrier();
		#endif // USE_MPI

		// Get information on Virtual and Physical RAM
		vector<unsigned long> totalMemory;
		GetTotalMemory(totalMemory);
		vector<unsigned long> processMemory;
		GetProcessMemory(processMemory);

		vector<int> gigabytes(2, 0);
		vector<int> megabytes(2, 0);
		vector<int> kilobytes(2, 0);

		for(int i=0; i< 2; i++)
		{
			gigabytes[i] = (processMemory[i] / 1000000);
			megabytes[i] = (processMemory[i] - gigabytes[i] * 1000000) / 1000;
			kilobytes[i] = (processMemory[i] - gigabytes[i] * 1000000 - megabytes[i] * 1000);
		}

		// Communicate total memory of processes- Only for Physical RAM
    int totalProcessesMemoryGigabytes = 0;
    int totalProcessesMemoryMegabytes = 0;
    int totalProcessesMemoryKilobytes = 0;

		#if USE_MPI == 1
		MPI::COMM_WORLD.Allreduce(&gigabytes[1], &totalProcessesMemoryGigabytes, 1, MPI::INT, MPI::SUM);
		MPI::COMM_WORLD.Allreduce(&megabytes[1], &totalProcessesMemoryMegabytes, 1, MPI::INT, MPI::SUM);
		MPI::COMM_WORLD.Allreduce(&kilobytes[1], &totalProcessesMemoryKilobytes, 1, MPI::INT, MPI::SUM);
		#elif USE_MPI == 0
    totalProcessesMemoryGigabytes = gigabytes[1];
		totalProcessesMemoryMegabytes = megabytes[1];
		totalProcessesMemoryKilobytes = kilobytes[1];
		#endif // USE_MPI

    unsigned long totalProcessMemory = (unsigned long)totalProcessesMemoryGigabytes * 1000000 + (unsigned long)totalProcessesMemoryMegabytes * 1000 + (unsigned long)totalProcessesMemoryKilobytes;
		totalProcessesMemoryGigabytes = totalProcessMemory / 1000000;
		totalProcessesMemoryMegabytes = (totalProcessMemory - totalProcessesMemoryGigabytes * 1000000) / 1000;
		totalProcessesMemoryKilobytes = (totalProcessMemory - totalProcessesMemoryGigabytes * 1000000 - totalProcessesMemoryMegabytes * 1000);

		if(totalAvailStartingMemory == 0)
			totalAvailStartingMemory = totalMemory[2] + totalProcessMemory;
		unsigned long totalAvailMemory = totalMemory[2];

		#if VERBOSE==1 || VERBOSE==3
		int availableMemoryGygabytes = 0;
		int availableMemoryMegabytes = 0;
		int availableMemoryKilobytes = 0;

		availableMemoryGygabytes = totalAvailMemory / 1000000;
		availableMemoryMegabytes = (totalAvailMemory - availableMemoryGygabytes * 1000000) / 1000;
		availableMemoryKilobytes = (totalAvailMemory - availableMemoryGygabytes * 1000000 - availableMemoryMegabytes * 1000);
		#endif // VERBOSE

		#if USE_MPI == 1
		MPI::COMM_WORLD.Barrier();
		#endif // USE_MPI

		// Get Information on PHYSICAL RAM
		if(Rank == 0)
		{
			#if VERBOSE==1 || VERBOSE==3
				if(checkProcessesMemory)
				{
					cout<< " -- "<< Output::BlueColor<< "Profiling"<< Output::EndColor<< ": RAM Memory '"<< nameMemory<<
						"': Total"<< "      "<< " Used / Free: "<<
						setfill(' ') << setw(5)<< totalProcessesMemoryGigabytes<< " / "<<
						setfill(' ') << setw(5)<< availableMemoryGygabytes<< " GB "<<
						setfill(' ') << setw(5)<< totalProcessesMemoryMegabytes<< " / "<<
						setfill(' ') << setw(5)<< availableMemoryMegabytes<< " MB "<<
						setfill(' ') << setw(5)<< totalProcessesMemoryKilobytes<< " / "<<
						setfill(' ') << setw(5)<< availableMemoryKilobytes<< " KB "<< " --"<< endl;
				}
				else
				{
					cout<< " -- "<< Output::BlueColor<< "Profiling"<< Output::EndColor<< ": RAM Memory '"<< nameMemory<<
						"': Used / Free: "<<
						totalProcessesMemoryGigabytes<< " / "<<
						availableMemoryGygabytes<< " GB "<<
						totalProcessesMemoryMegabytes<< " / "<<
						availableMemoryMegabytes<< " MB "<<
						totalProcessesMemoryKilobytes<< " / "<<
						availableMemoryKilobytes<< " KB "<< " --"<< endl;
				}
			#endif

			ostringstream nameFile, nameFolder;

			string outputData = "";
			if (ConfigFile::IsPropertyDefault(ConfigFile::FilesParam().OutputData()))
				outputData = ConfigFile::InParam().InputData();
			else
				outputData = ConfigFile::FilesParam().OutputData();

			nameFolder<< ConfigFile::FilesParam().OutputFolder();
			nameFolder<< outputData<< "/";
			nameFolder<< ConfigFile::InParam().RunId()<< "/";
			nameFolder<< ConfigFile::Log().LogFolder();
			Output::CreateFolder(nameFolder.str());

			nameFile<< nameFolder.str()<< ConfigFile::Log().MemoryFile();
			bool fileExists = Output::FileExists(nameFile.str());

			LogFile::CheckFileSize(nameFile.str());

			ofstream outFile(nameFile.str().c_str(), ios_base::app);
			outFile.precision(8);

			if(!fileExists)
			{
				outFile<< "TotProc"<< " ";
				outFile<< "Type"<< " ";
				outFile<< "MemoryUsed(KB)"<< " ";
				outFile<< "MemoryAvail(KB)"<< " ";
				outFile<< "PercUsed(%)"<< endl;
			}
			outFile<< NumberProcesses<< " "<<
				nameMemory<< " "<<
				totalProcessMemory<< " "<<
				totalAvailMemory<< " "<<
				(totalProcessMemory * 100 / totalAvailStartingMemory)<< endl;
		}
		#if USE_MPI == 1
		MPI::COMM_WORLD.Barrier();
		#endif // USE_MPI

		if(!checkProcessesMemory)
			return;

		#if VERBOSE==1 || VERBOSE==3
			cout<< " -- "<< Output::BlueColor<< "Profiling"<< Output::EndColor<< ": RAM Memory '"<< nameMemory<<
				"': Process "<< setfill(' ') << setw(3)<< Rank << " Used / Free: "<<
				setfill(' ') << setw(5)<< gigabytes[1]<< " / "<<
				setfill(' ') << setw(5)<< availableMemoryGygabytes<< " GB "<<
				setfill(' ') << setw(5)<< megabytes[1]<< " / "<<
				setfill(' ') << setw(5)<< availableMemoryMegabytes<< " MB "<<
				setfill(' ') << setw(5)<< kilobytes[1]<< " / "<<
				setfill(' ') << setw(5)<< availableMemoryKilobytes<< " KB "<< " --"<< endl;
		#endif

		#if USE_MPI == 1
		MPI::COMM_WORLD.Barrier();
		#endif // USE_MPI
	}
	// ***************************************************************************
}
