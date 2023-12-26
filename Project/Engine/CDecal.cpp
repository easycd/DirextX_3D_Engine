#include "pch.h"
#include "CDecal.h"

#include "CResMgr.h"
#include "CMesh.h"
#include "CMaterial.h"

CDecal::CDecal()
	: CRenderComponent(COMPONENT_TYPE::DECAL)
{
	SetMesh(CResMgr::GetInst()->FindRes<CMesh>(L"RectMesh"));
}

CDecal::~CDecal()
{

}

void CDecal::finaltick()
{
}

void CDecal::render()
{
}