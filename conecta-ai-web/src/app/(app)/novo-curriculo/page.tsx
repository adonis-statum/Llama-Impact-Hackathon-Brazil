'use client';

import React, { useState } from 'react';
import { Card } from '@/components/ui/card';
import { FormControl, FormLabel } from '@/components/ui/form';
import { Input } from '@/components/ui/input';

interface ContactInformation {
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
}

interface WorkExperience {
  jobTitle: string;
  companyName: string;
  datesOfEmployment: string;
  briefDescription: string;
}

interface Education {
  degree: string;
  institution: string;
  datesOfAttendance: string;
  briefDescription: string;
}

interface Skills {
  skillName: string;
  levelOfProficiency: string;
}

const ResumeGeneratorForm = () => {
  const [contactInformation, setContactInformation] = useState<ContactInformation>({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
  });

  const [workExperience, setWorkExperience] = useState<WorkExperience[]>([
    {
      jobTitle: '',
      companyName: '',
      datesOfEmployment: '',
      briefDescription: '',
    },
  ]);

  const [education, setEducation] = useState<Education[]>([
    {
      degree: '',
      institution: '',
      datesOfAttendance: '',
      briefDescription: '',
    },
  ]);

  const [skills, setSkills] = useState<Skills[]>([
    {
      skillName: '',
      levelOfProficiency: '',
    },
  ]);

  const handleContactInformationChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setContactInformation({
      ...contactInformation,
      [event.target.name]: event.target.value,
    });
  };

  const handleWorkExperienceChange = (
    index: number,
    event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>
  ) => {
    const newWorkExperience = [...workExperience];
    newWorkExperience[index][event.target.name as keyof WorkExperience] = event.target.value;
    setWorkExperience(newWorkExperience);
  };

  const handleEducationChange = (index: number, event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => {
    const newEducation = [...education];
    newEducation[index][event.target.name as keyof Education] = event.target.value;
    setEducation(newEducation);
  };

  const handleSkillsChange = (index: number, event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => {
    const newSkills = [...skills];
    newSkills[index][event.target.name as keyof Skills] = event.target.value;
    setSkills(newSkills);
  };

  const handleAddWorkExperience = () => {
    setWorkExperience([
      ...workExperience,
      {
        jobTitle: '',
        companyName: '',
        datesOfEmployment: '',
        briefDescription: '',
      },
    ]);
  };

  const handleAddEducation = () => {
    setEducation([
      ...education,
      {
        degree: '',
        institution: '',
        datesOfAttendance: '',
        briefDescription: '',
      },
    ]);
  };

  const handleAddSkills = () => {
    setSkills([
      ...skills,
      {
        skillName: '',
        levelOfProficiency: '',
      },
    ]);
  };

  const handleGenerateResume = () => {
    // TO DO: generate resume based on form data
  };

  return (
    <div className='max-w-md mx-auto p-4'>
      <h2 className='text-lg font-bold mb-4'>Resume Generator</h2>
      <Card>
        {workExperience.map((experience, index) => (
          <div key={index}>
            <FormControl>
              <FormLabel>Job Title:</FormLabel>
              <Input
                type='text'
                name='jobTitle'
                value={experience.jobTitle}
                onChange={(event) => handleWorkExperienceChange(index, event)}
              />
            </FormControl>
            <FormControl>
              <FormLabel>Company Name:</FormLabel>
              <Input
                type='text'
                name='companyName'
                value={experience.companyName}
                onChange={(event) => handleWorkExperienceChange(index, event)}
              />
            </FormControl>
            <FormControl>
              <FormLabel>Dates of Employment:</FormLabel>
              <Input
                type='text'
                name='datesOfEmployment'
                value={experience.datesOfEmployment}
                onChange={(event) => handleWorkExperienceChange(index, event)}
              />
            </FormControl>
            <FormControl>
              <FormLabel>Brief Description:</FormLabel>
              <Input
                type='text'
                name='briefDescription'
                value={experience.briefDescription}
                onChange={(event) => handleWorkExperienceChange(index, event)}
              />
            </FormControl>
          </div>
        ))}
      </Card>
    </div>
  );
};

export default ResumeGeneratorForm;
